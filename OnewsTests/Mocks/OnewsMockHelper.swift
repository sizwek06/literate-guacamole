//
//  OnewsMockHelper.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/04/20.
//

import Foundation
import OnewsSDK

class OnewsMockHelper: OnewsArticleProtocol {

    var invokeSuccess = false
    var invokeEmpty = false
    var invokeError = false
    
    private static func fetchJsonData(in file: String) throws -> Data {
        let path = Bundle(for: self).path(forResource: file, ofType: "json")
        return try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
    }
    
    static func fetchAndUnbox<T: Decodable>(in file: String) -> T? {
        do {
            let data = try OnewsMockHelper.fetchJsonData(in: file)
            let details: T = try JSONDecoder().decode(T.self, from: data)
            return details
        } catch {
            print("Cannot convert json file for testing")
        }
        return nil
    }
    
    static func returnArticlesResponse() -> NewsArticleResponse? {
        return OnewsMockHelper.fetchAndUnbox(in: "ArticleResponse")
    }
    
    static func returnEmptyResponse() -> NewsArticleResponse? {
        return OnewsMockHelper.fetchAndUnbox(in: "Empty")
    }
    
    func handleGetArticlesRequest(_ url: String, completion: @escaping (NewsArticleResponse?, Error?) -> Void) {
        if invokeSuccess {
            completion(OnewsMockHelper.returnArticlesResponse(), nil)
        }
        
        if invokeEmpty {
            completion(OnewsMockHelper.returnEmptyResponse(), nil)
        }
        
        if invokeError {
            completion(nil, NSError(domain: "MockNetworkingServiceErrorDomain",
                                        code: 808,
                                        userInfo: [NSLocalizedDescriptionKey: "Unit Test: Error"]
                                       ))
        }
    }
    
    func reset() {
        invokeSuccess = false
        invokeEmpty = false
        invokeError = false
    }
}
