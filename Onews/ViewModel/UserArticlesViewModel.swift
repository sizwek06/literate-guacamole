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
    let fireBaseDB = Firestore.firestore()
    
    var articlesArray: [Article] = []
    var fireBaseArray: [String] = []
    
    let onewsFireStore = OnewsFirestore()
    
    func queryCurrentUserArticles(using uuid: String) {
        
        self.userArticleDelegate?.showUserArticlesLoading()
        
        onewsFireStore.queryUserArticles(using: uuid, completion: { [weak self] articlesArray, error in
            guard let self else { return }
            
            if let err = error {
                self.userArticleDelegate?.didFailWithError(error: err.localizedDescription)
            } else {
                self.articlesArray = articlesArray ?? []
                self.userArticleDelegate?.didReceiveArticlesSuccessfully()
            }
        })
    }
    
    func deleteUserArticles(using articleURL: String, uuid: String) {
        self.userArticleDelegate?.showUserArticlesLoading()
        
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
              self.userArticleDelegate?.didReceiveArticlesSuccessfully()
            }
          }
        }
    }
}

class OnewsFirestore {
    
    func queryUserArticles(using uuid: String,
                           completion: @escaping ([Article]?, Error?) -> Void) {
        var articlesArray = [Article]()
        
        Firestore.firestore().collection(K.fireStoreDb.fireStoreDbCollection)
        .whereField(K.fireStoreDb.artileUUIDfield, isEqualTo: uuid).getDocuments { (snapshot, error) in
            
            guard let querySnapshot = snapshot else {
                if let error = error {
                    completion(nil, error)
                }
                return
            }
            print("FireStore Count: \(querySnapshot.documents.count)")
            
            for document in querySnapshot.documents {
                
                articlesArray.append(try! document.data(as: Article.self))
                print("Firebase Document: ", document)
                print("articlesArray are \(articlesArray)")
            }
            completion(articlesArray, nil)
        }
    }
}
