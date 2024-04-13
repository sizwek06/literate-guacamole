//
//  SettingsViewController+Delegate.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/30.
//

import Foundation
import UIKit
import FirebaseAuth

extension SettingsViewController: UserAcessDelegate {
    
    func confirmLogOut() {
        let alert = UIAlertController(title: "Sign out", message: "\nAre you sure you want to Sign out", preferredStyle: .alert)
            
        alert.addAction(UIAlertAction(title: K.alertYes, style: .destructive, handler: { _ in
                self.userAccessViewModel.signOutUser()
                super.currentState = .signedOut
                self.setupTableView()
                self.refreshUserDetails(1)
                UserDefaults.standard.set(false, forKey: K.userDefaultSignedInKey)
                UserDefaults.standard.set(false, forKey: K.userDefaultBiometricsKey)
                UserDefaults.standard.set("us", forKey: K.userDefaultRegionKey)
            }))
            
        alert.addAction(UIAlertAction(title: K.alertCancel, style: .cancel, handler: { _ in
                alert.dismiss(animated: true)
            }))
        
        self.present(alert, animated: true)
    }
    
    func successfulUserSignIn(user: User, isRegistration: Bool) {
        
        guard let email = user.email else { return }
       
        UserDefaults.standard.set(email, forKey: K.userDefaultEmailKey)
        UserDefaults.standard.set(user.uid, forKey: K.userDefaultUUIDKey)
        
        super.self.currentState = .signedInNoFaceId
        self.currentState = .signedInNoFaceId
        self.setupTableView()
        
        self.dismiss(animated: true)
    }
    
    func didFailWithError(error: String, isRegistration: Bool) {
        let alert = UIAlertController(title: K.alertErrorTitle, message: error, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: K.alertOK, style: UIAlertAction.Style.default, handler: { (_) in
            alert.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: K.alertCancel, style: UIAlertAction.Style.cancel, handler: { (_) in
            alert.dismiss(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showLoader() {
        OnewsLoaderViewController.sharedInstance.setDisplay(loadingText: K.loadingUserSettingsText)
        OnewsLoaderViewController.sharedInstance.show()
    }
    
    func hideLoader() {
        OnewsLoaderViewController.sharedInstance.hide()
    }
}
