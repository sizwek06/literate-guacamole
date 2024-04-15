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
    
    var userArticleDelegate: UserArticlesDelegate?
    let fireBaseDB = Firestore.firestore().collection(K.fireStoreDb.fireStoreDbCollection)
    
    var articlesArray: [Article] = []
    var fireBaseArray: [String] = []
    
    let onewsFireStore = OnewsFirestore()
    
    func queryCurrentUserArticles(using uuid: String) {
        
        self.userArticleDelegate?.showUserArticlesLoading()
        
        let query = fireBaseDB
            .whereField(K.fireStoreDb.artileUUIDfield, isEqualTo: uuid)
        
        OnewsFirestore().queryUserArticles(using: query, completion: { [weak self] articlesArray, error in
            guard let self else { return }
            
            if let err = error {
                self.userArticleDelegate?.didFailWithError(error: err.localizedDescription)
            } else {
                self.articlesArray = articlesArray ?? []
                self.userArticleDelegate?.didReceiveArticlesSuccessfully()
            }
        })
    }
    
    func deleteUserArticle(_ articleURL: String, uuid: String) {
        self.userArticleDelegate?.showUserArticlesLoading()
        
        let query = fireBaseDB
            .whereField(K.fireStoreDb.artileUrlField, isEqualTo: articleURL)
            .whereField(K.fireStoreDb.artileUUIDfield, isEqualTo: uuid)
        
        OnewsFirestore().deleteUserArticles(query, completion: { [weak self] error in
            guard let self else { return }
            
            if let err = error {
                self.userArticleDelegate?.didFailWithError(error: err.localizedDescription)
            } else {
                self.userArticleDelegate?.didReceiveArticlesSuccessfully()
            }
        })
    }
}
