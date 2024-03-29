//
//  SettingsViewController.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/27.
//

import Foundation
import UIKit
import FirebaseAuth

class SettingsViewController: UserViewController {
    
    var userAccessViewModel = UserAcessViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        super.tableView.register(UINib(nibName: "UserProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "userProfileTableViewCell")
        super.tableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "settingsCell")
        super.tableView.register(SingleLabelTableViewCell.self, forCellReuseIdentifier: SingleLabelTableViewCell.identifier)
        
        userAccessViewModel.delegate = self
        
        DispatchQueue.main.async {
            self.tableView.refreshControl?.beginRefreshing()
            self.setUpView()
        }
        
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
    func showSignInSheet() {
        let alert = UIAlertController(title: nil, message: "Please Select an Option to continue", preferredStyle: .actionSheet)
            
        alert.addAction(UIAlertAction(title: K.signInText, style: .destructive, handler: { _ in
                self.showUserAccessController(false)
            }))
        
        alert.addAction(UIAlertAction(title: K.signUpText, style: .default, handler: { _ in
                self.showUserAccessController(true)
            }))
            
        alert.addAction(UIAlertAction(title: K.alertCancel, style: .cancel, handler: { _ in
                alert.dismiss(animated: true)
            }))
        
        self.present(alert, animated: true)
    }
    
    @objc func updateCurrentUser(notification: NSNotification) {
        self.userName = OnewsUserDefaults.sharedInstance.userEmail
    }
    
    @objc func updateSignInState(notfication: NSNotification) {
        self.isSignedIn = OnewsUserDefaults.sharedInstance.isSignedIn!
    }
}

extension SettingsViewController: UserAcessDelegate {
    
    func confirmLogOut() {
        let alert = UIAlertController(title: "Log out", message: "\nAre you sure you want to Log Out", preferredStyle: .alert)
            
        alert.addAction(UIAlertAction(title: K.alertYes, style: .destructive, handler: { _ in
                self.userAccessViewModel.signOutUser()
            }))
            
        alert.addAction(UIAlertAction(title: K.alertCancel, style: .cancel, handler: { _ in
                alert.dismiss(animated: true)
            }))
        
        self.present(alert, animated: true)
    }
    
    func successfulUserSignIn(user: User, isRegistration: Bool) {
        self.setUpView()
        guard let email = user.email else { return }
       
        OnewsUserDefaults.sharedInstance.saveLoggedInUser(email: email)
        
        OnewsUserDefaults.sharedInstance.loadDefaults()
        
        print("Sign In/Up Successful with OnewsUserDefaults: ",UserDefaults.standard.string(forKey: "user_name"))
        print("Is the user logged in: ", UserDefaults.standard.string(forKey: "user_name"))
        
        self.dismiss(animated: true)
        
        print("SettingsView: User email: ", email as Any)
        print("SettingsView: User details: ", user.displayName as Any)
    }
    
    func didFailWithError(error: String, isRegistration: Bool) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: K.alertOK, style: UIAlertAction.Style.default, handler: { (_) in
            alert.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: K.alertCancel, style: UIAlertAction.Style.cancel, handler: { (_) in
            alert.dismiss(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showLoader() {
        OnewsLoaderViewController.sharedInstance.setDisplay(loadingText: K.loadingUserText)
        OnewsLoaderViewController.sharedInstance.show()
    }
    
    func hideLoader() {
        OnewsLoaderViewController.sharedInstance.hide()
    }
}
