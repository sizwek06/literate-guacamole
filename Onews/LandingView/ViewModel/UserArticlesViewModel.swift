//
//  UserArticlesViewModel.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/29.
//

import Foundation
import FirebaseFirestore

class UserArticlesViewModel {
    
    var userArticleDelegate: UserArticlesDelegate?
    let fireBaseDB = Firestore.firestore()
    
    var articlesArray: [Article] = []
    
    func featchUserArticles() async {
        self.userArticleDelegate?.showNewsLoading()
        let docRef = fireBaseDB.collection(K.fireStoreDb.fireStoreDbCollection).document("ReferenceArticle")
        
        do {
            self.userArticleDelegate?.hideNewsLoading()
            let document = try await docRef.getDocument(as: Article.self)
             print(document)
        } catch {
            self.userArticleDelegate?.didFailWithError(error: error.localizedDescription)
            print("Error getting document: \(error)")
        }
    }
}
