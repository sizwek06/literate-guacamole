//
//  ArticleManager.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/07/01.
//

import Foundation

struct ArticleManager {
    var delegate: ArticleDelegate?
    func fetchNewsArticles() {
        var urlString = ""

        urlString = K.newsArticleURL
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, _, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        delegate?.didFailWithError(error: error.localizedDescription)
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
            LandingViewModel.shared.articlesArray = decodedData.articles
            LandingViewModel.shared.mainArticle = decodedData.articles.first
            LandingViewModel.shared.articlesArray.remove(at: 0)
        } catch {
            delegate?.didFailWithError(error: error.localizedDescription)
        }
    }
}
