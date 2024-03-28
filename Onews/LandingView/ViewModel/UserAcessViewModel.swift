//
//  UserAcessViewModel.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/27.
//

import Foundation
import FirebaseAuth

class UserAcessViewModel {
    
    var delegate: UserAcessDelegate?
    let userDefaults = UserDefaults.standard
    
    func registerUser(email: String, password: String) {
        self.delegate?.showLoader()
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                self.delegate?.hideLoader()
                if let e = error {
                    self.delegate?.didFailWithError(error: e.localizedDescription,
                                                    isRegistration: true)
                } else if let auth = authResult {
//                    self.addUserDisplayName(currentUser: auth.user, displayName: username)
                    
                    self.delegate?.successfulRegistration(user: auth.user,
                                                          isRegistration: true)
                    self.userDefaults.set(auth.user, forKey: "currentUser")
//                    let user = Auth.auth().currentUser
                    
                }
            }
        }
    
    //TODO: Register and add username?
//    func addUserDisplayName(currentUser: User, displayName: String) {
//        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
//    changeRequest?.displayName = username
//    
//    changeRequest?.commitChanges { (error) in
//        if let e = error {
//            self.delegate?.didFailWithError(error: e.localizedDescription,
//                                            isRegistration: true)
//        }
//    }
//    }
}
