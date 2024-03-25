//
//  LandingViewModel.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/03/25.
//

import Foundation

class ArticlesListViewModel {
    
    static let shared = ArticlesListViewModel()
    
    var articlesArray: [Article] = []
    
    var delegate: ArticleDelegate?
    
    func fetchNewsArticles() {
        performRequest(with: K.newsArticleURL)
    }
    
    func searchArticleTopic(with searchPhrase: String) {
        performRequest(with: K.searchURL + searchPhrase)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, _, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        self.delegate?.didFailWithError(error: error.localizedDescription)
                        return
                    } else if let safeData = data {
                        self.parseJSON(safeData)
                        self.delegate?.didReceiveArticlesSuccessfully()
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ newsData: Data) {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(NewsArticle.self, from: newsData)
            self.articlesArray = decodedData.articles
            self.articlesArray = articlesArray.filter { $0.title != "[Removed]" }
        } catch {
            delegate?.didFailWithError(error: error.localizedDescription)
        }
    }
}
