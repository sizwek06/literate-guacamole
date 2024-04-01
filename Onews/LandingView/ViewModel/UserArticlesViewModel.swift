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
    var fireBaseArray: [String] = []
    
    func queryUserArticles(using uuid: String, completion: @escaping ([Article]) -> Void) {
        self.userArticleDelegate?.showNewsLoading()
        fireBaseDB.collection(K.fireStoreDb.fireStoreDbCollection)
            .whereField(K.fireStoreDb.artileUUIDfield, isEqualTo: uuid)
            .limit(to: 50)
            .addSnapshotListener { [weak self] (querySnapshot, err) in
            
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
    
    func deleteUserArticles(using articleURL: String, uuid: String) {
        self.userArticleDelegate?.showNewsLoading()
        
        fireBaseDB.collection(K.fireStoreDb.fireStoreDbCollection)
            .whereField(K.fireStoreDb.artileUrlField, isEqualTo: articleURL)
            .whereField(K.fireStoreDb.artileUUIDfield, isEqualTo: uuid)
            .getDocuments { [weak self] (querySnapshot, err) in
               
            guard let self else { return }
            self.userArticleDelegate?.hideNewsLoading()
          if let err = err {
              self.userArticleDelegate?.didFailWithError(error: err.localizedDescription)
          } else {
            for document in querySnapshot!.documents {
              document.reference.delete()
            }
          }
        }
    }
}
