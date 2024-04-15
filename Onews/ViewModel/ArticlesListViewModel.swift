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
    var articleDelegate: ArticleDelegate?
    let fireBaseDB = Firestore.firestore()
    let articleRequest = ArticleRequest()
    let onewsFireStore = OnewsFirestore()
    
    func getArticles(_ searchPhrase: String? = nil) {
        self.articleDelegate?.showNewsLoading()
        
        var articleURL: String
        
        if let searchPhrase = searchPhrase {
            articleURL = K.searchURL + searchPhrase
        } else {
            articleURL = K.newsArticleURL + (UserDefaults.standard.string(forKey: K.userDefaultRegionKey) ?? "us")
        }
                                             
        articleRequest.performGetArticlesRequest(with: articleURL, { [weak self] result in
            guard let self else { return }
            
            self.articleDelegate?.hideNewsLoading()
            
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                self.articlesArray = data
                
                self.articleDelegate?.didReceiveArticlesSuccessfully()
                }
            case .failure(let error):
                self.articleDelegate?.didFailWithError(error: error.localizedDescription)
            }
        })
   }
    
    func saveNewsArticle(using newsArticle: Article, userUID: String) {
        self.articleDelegate?.showNewsLoading()
            
        onewsFireStore.saveNewsArticle(using: newsArticle, userUID: userUID, completion: { [weak self] error in
            guard let self else { return }
        
            self.articleDelegate?.hideNewsLoading()
        
            if let err = error {
                self.articleDelegate?.didFailWithError(error: err.localizedDescription)
            }
        })
    }
}
