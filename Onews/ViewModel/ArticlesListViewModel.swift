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
    
    var articleDelegate: ArticleDelegate
    let articleRequest: OnewsArticleProtocol
    var onewsFireStore: OnewsFirestoreProtocol
    
    let fireBaseDB = Firestore.firestore()
    var userDefaultRegion = UserDefaults.standard.string(forKey: K.userDefaultRegionKey)
    
    var articlesArray: [Article] = []
    
    init(articleDelegate: ArticleDelegate, 
         articleRequest: OnewsArticleProtocol,
         onewsFirestore: OnewsFirestoreProtocol) {
        
        self.articleDelegate = articleDelegate
        self.articleRequest = articleRequest
        self.onewsFireStore = onewsFirestore
        // Needed to expose these for the unit tests to actually have code coverage.
    }
    
    func getArticles(_ searchPhrase: String? = nil) {
        self.articleDelegate.showNewsLoading()
        
        var articleURL: String
        
        if let searchPhrase = searchPhrase {
            articleURL = K.searchURL + searchPhrase
        } else {
            articleURL = K.newsArticleURL + (self.userDefaultRegion ?? "us")
        }
        
        articleRequest.handleGetArticlesRequest(articleURL, completion: { newsResults, error in
            
            self.articleDelegate.hideNewsLoading()
            
            if let error = error {
                self.articleDelegate.didFailWithError(error: error.localizedDescription)
            } else {
                guard let results = newsResults else { return }
                self.articlesArray = results.articles.filter { $0.title != "[Removed]" }
                self.articleDelegate.didReceiveArticlesSuccessfully()
            }
        })
    }
    
    func saveNewsArticle(using newsArticle: Article, userUID: String) {
        self.articleDelegate.showNewsLoading()
        
        onewsFireStore.saveNewsArticle(using: newsArticle, userUID: userUID, completion: { [weak self] error in
            guard let self else { return }
            
            self.articleDelegate.hideNewsLoading()
            
            if let err = error {
                self.articleDelegate.didFailWithError(error: err.localizedDescription)
            }
        })
    }
}
