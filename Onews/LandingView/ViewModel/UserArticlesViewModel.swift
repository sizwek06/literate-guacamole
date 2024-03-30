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
    
    func queryUserArticles(using uuid: String, completion: @escaping ([Article])->()) {
        self.userArticleDelegate?.showNewsLoading()
        fireBaseDB.collection(K.fireStoreDb.fireStoreDbCollection).addSnapshotListener { [weak self] (querySnapshot, err) in
            
            guard let self else { return }
            self.userArticleDelegate?.hideNewsLoading()
            if let err = err {
                self.userArticleDelegate?.didFailWithError(error: err.localizedDescription)
            } else {
                guard let documents = querySnapshot?.documents else {
                    print("no documents")
                    return
                }
                self.articlesArray = documents
                    .compactMap { document -> Article in
                        return try! document.data(as: Article.self)
                    }
                completion(self.articlesArray)
                self.userArticleDelegate?.didReceiveArticlesSuccessfully()
            }
        }
    }
}
