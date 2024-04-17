//
//  UserAcessViewModel.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/27.
//

import Foundation
import FirebaseAuth

class UserAccessViewModel {
    
    var userAccessDelegate: UserAcessDelegate
    
    init(userAccessDelegate: UserAcessDelegate) {
        self.userAccessDelegate = userAccessDelegate
    }
    
    func signUp(email: String, password: String) {
        self.userAccessDelegate.showLoader()
        
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                
                guard let self else { return }
                self.userAccessDelegate.hideLoader()
                
                if let e = error {
                    self.userAccessDelegate.didFailWithError(error: e.localizedDescription,
                                                    isRegistration: true)
                } else if let auth = authResult {
                    self.userAccessDelegate.successfulUserSignIn(user: auth.user,
                                                          isRegistration: true)
                }
            }
        }
    
    func signInUser(email: String, password: String) {
        self.userAccessDelegate.showLoader()
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self else { return }
            self.userAccessDelegate.hideLoader()
            
            if let e = error {
                self.userAccessDelegate.didFailWithError(error: e.localizedDescription,
                                                isRegistration: false)
            } else if let auth = authResult {
                self.userAccessDelegate.successfulUserSignIn(user: auth.user,
                                                      isRegistration: false)
            }
        }
    }
    
    func signOutUser() {
        self.userAccessDelegate.showLoader()
        
        do {
            self.userAccessDelegate.hideLoader()
            try Auth.auth().signOut()
            
            UserDefaults.standard.removeObject(forKey: K.userDefaultEmailKey)
            UserDefaults.standard.removeObject(forKey: K.userDefaultUUIDKey)
            UserDefaults.standard.set(false, forKey: K.userDefaultSignedInKey)
        } catch {
            self.userAccessDelegate.didFailWithError(error: error.localizedDescription,
                                            isRegistration: true)
        }
    }
}
