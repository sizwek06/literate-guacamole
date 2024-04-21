//
//  FirestoreMockHelper.swift
//  OnewsTests
//
//  Created by Sizwe Khathi on 2024/04/21.
//

import Foundation
import OnewsSDK
import FirebaseFirestoreInternal

class FirestoreMockHelper: OnewsFirestoreProtocol {
    
    var invokeSuccess = false
    var invokeEmpty = false
    var invokeError = false
    
    var articlesArray: [Article] = []
    var error = NSError(domain: "MockNetworkingServiceErrorDomain",
                        code: 808,
                        userInfo: [NSLocalizedDescriptionKey: "Unit Test: Firestore Error"]
                       )
    
    func saveNewsArticle(using newsArticle: Article, userUID: String, completion: @escaping (Error?) -> Void) {
        if invokeSuccess {
            completion(nil)
        }
        
        if invokeError {
            completion(error)
        }
    }
    
    func queryUserArticles(using query: Query, completion: @escaping ([Article]?, Error?) -> Void) {
        if invokeSuccess {
            for _ in 1...3 {
                self.articlesArray.append(OnewsMockHelper.returnArticleExampleResponse()!)
            }
            completion(articlesArray, nil)
        }
        
        if invokeEmpty {
            completion(nil, nil)
        }
        
        if invokeError {
            completion(nil, error)
        }
    }
    
    func deleteUserArticles(_ query: Query, completion: @escaping (Error?) -> Void) {
        if invokeSuccess {
            completion(nil)
        }
        
        if invokeError {
            completion(error)
        }
    }
    
    func reset() {
        invokeSuccess = false
        invokeEmpty = false
        invokeError = false
    }
}
