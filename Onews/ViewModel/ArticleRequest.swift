//
//  ArticleRequest.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/04/08.
//

import Foundation

open class ArticleRequest {
    
    func performGetArticlesRequest(with urlString: String,
                                   _ completion: @escaping (_ result: Result<[Article], Error>) -> Void) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { [weak self] (data, _, error) in
                
                guard let self else { return }
                
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        return
                    } else if let safeData = data {
                        completion(.success(self.parseJSON(safeData)))
                        return
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ newsData: Data) -> [Article] {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(NewsArticle.self, from: newsData)
            return decodedData.articles.filter { $0.title != "[Removed]" }
        } catch {
            return []
        }
    }
}
