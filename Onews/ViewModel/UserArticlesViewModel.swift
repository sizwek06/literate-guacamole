//
//  UserArticlesViewModel.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/29.
//

import Foundation
import FirebaseFirestore
import OnewsSDK

class UserArticlesViewModel {

    var userArticleDelegate: UserArticlesDelegate
    let onewsFireStore: OnewsFirestoreProtocol
    
    var articlesArray: [Article] = []
    
    let fireBaseDB = Firestore.firestore().collection(K.fireStoreDb.fireStoreDbCollection)
    
    init(userArticleDelegate: UserArticlesDelegate,
         onewsFireStore: OnewsFirestoreProtocol) {
        
        self.userArticleDelegate = userArticleDelegate
        self.onewsFireStore = onewsFireStore
    }
    
    func queryCurrentUserArticles(using uuid: String) {
        
        self.userArticleDelegate.showUserArticlesLoading()
        
        let query = fireBaseDB
            .whereField(K.fireStoreDb.artileUUIDfield, isEqualTo: uuid)
        
        onewsFireStore.queryUserArticles(using: query, completion: { [weak self] articlesArray, error in
            guard let self else { return }
            
            self.userArticleDelegate.hideNewsLoading()
            if let err = error {
                self.userArticleDelegate.didFailWithError(error: err.localizedDescription)
            } else {
                self.articlesArray = articlesArray ?? []
                self.userArticleDelegate.didReceiveArticlesSuccessfully()
            }
        })
    }
    
    func deleteUserArticle(_ articleURL: String, uuid: String) {
        self.userArticleDelegate.showUserArticlesLoading()
        
        let query = fireBaseDB
            .whereField(K.fireStoreDb.artileUrlField, isEqualTo: articleURL)
            .whereField(K.fireStoreDb.artileUUIDfield, isEqualTo: uuid)
        
        onewsFireStore.deleteUserArticles(query, completion: { [weak self] error in
            guard let self else { return }
            
            self.userArticleDelegate.hideNewsLoading()
            if let err = error {
                self.userArticleDelegate.didFailWithError(error: err.localizedDescription)
            } else {
                self.userArticleDelegate.didReceiveArticlesSuccessfully()
            }
        })
    }
}
