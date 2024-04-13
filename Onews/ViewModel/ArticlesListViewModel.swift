//
//  LandingViewModel.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/03/25.
//

import Foundation
import FirebaseFirestore
import OnewsSDK

class ArticlesListViewModel {
    
    var articlesArray: [Article] = []
    var delegate: ArticleDelegate?
    let fireBaseDB = Firestore.firestore()
    let articleRequest = ArticleRequest()
    
    func getArticles(_ searchPhrase: String? = nil) {
        self.delegate?.showNewsLoading()
        
        var articleURL: String
        
        if let searchPhrase = searchPhrase {
            articleURL = K.searchURL + searchPhrase
        } else {
            articleURL = K.newsArticleURL + (UserDefaults.standard.string(forKey: K.userDefaultRegionKey) ?? "us")
        }
                                             
        articleRequest.performGetArticlesRequest(with: articleURL, { [weak self] result in
            guard let self else { return }
            
            self.delegate?.hideNewsLoading()
            
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                self.articlesArray = data
                
                self.delegate?.didReceiveArticlesSuccessfully()
                }
            case .failure(let error):
                self.delegate?.didFailWithError(error: error.localizedDescription)
            }
        })
   }
    
    func saveNewsArticle(using newsArticle: Article) {
        self.delegate?.showNewsLoading()
        let newsArticleDb = fireBaseDB.collection(K.fireStoreDb.fireStoreDbCollection).document()
            
        if let userUID = UserDefaults.standard.object(forKey: K.userDefaultUUIDKey) {
            
        self.delegate?.hideNewsLoading()
        do {
            var dbArticle = newsArticle
            dbArticle.uuid = userUID as? String
            
            try newsArticleDb.setData(from: dbArticle)
            } catch {
                self.delegate?.didFailWithError(error: error.localizedDescription)
            }
        }
    }
}
