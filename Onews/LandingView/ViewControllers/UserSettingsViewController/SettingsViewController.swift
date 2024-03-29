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
        tableView.refreshControl?.addTarget(self, action: #selector(setUpView), for: .valueChanged)
        
        userAccessViewModel.delegate = self
        
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
    func showSignInSheet() {
        let alert = UIAlertController(title: nil, message: "Please Select an Option to continue", preferredStyle: .actionSheet)
            
        alert.addAction(UIAlertAction(title: K.signUpText, style: .default, handler: { _ in
                self.showUserAccessController(true)
            }))

        alert.addAction(UIAlertAction(title: K.signInText, style: .destructive, handler: { _ in
                self.showUserAccessController(false)
            }))
            
        alert.addAction(UIAlertAction(title: K.alertCancel, style: .cancel, handler: { _ in
                alert.dismiss(animated: true)
            }))
        
        self.present(alert, animated: true)
    }
}

extension SettingsViewController: UserAcessDelegate {
    
    func successfulUserSignIn(user: User, isRegistration: Bool) {
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
