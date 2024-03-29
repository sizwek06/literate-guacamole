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
    
    func registerUser(email: String, password: String) {
        self.delegate?.showLoader()
        
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                
                guard let self else { return }
                self.delegate?.hideLoader()
                
                if let e = error {
                    self.delegate?.didFailWithError(error: e.localizedDescription,
                                                    isRegistration: true)
                } else if let auth = authResult {
                    self.delegate?.successfulUserSignIn(user: auth.user,
                                                          isRegistration: true)
                    
                    guard let email = auth.user.email else { return }
                    OnewsUserDefaults.sharedInstance.saveLoggedInUser(user: email)
                }
            }
        }
    
    func logInUser(email: String, password: String) {
        print("Logg In called")
        self.delegate?.showLoader()
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self else { return }
            self.delegate?.hideLoader()
            
            if let e = error {
                self.delegate?.didFailWithError(error: e.localizedDescription,
                                                isRegistration: true)
            } else if let auth = authResult {
                self.delegate?.successfulUserSignIn(user: auth.user,
                                                      isRegistration: true)
                print("Logg In Successful")
                guard let email = auth.user.email else { return }
                OnewsUserDefaults.sharedInstance.saveLoggedInUser(user: email)
                print("Log In Successful with OnewsUserDefaults: ", OnewsUserDefaults.sharedInstance.userEmail)
            }
        }
    }
    
    // TODO: Register and add username?
//    self.addUserDisplayName(currentUser: auth.user, displayName: username)
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
