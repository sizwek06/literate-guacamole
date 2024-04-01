//
//  SettingsViewController.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/27.
//

import Foundation
import UIKit
import FirebaseAuth

class SettingsViewController: ProfileViewController {
    
    var userAccessViewModel = UserAccessViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        title = "Settings"
        super.tableView.register(UINib(nibName: "UserProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "userProfileTableViewCell")
        super.tableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "settingsCell")
        super.tableView.register(SingleLabelTableViewCell.self, forCellReuseIdentifier: SingleLabelTableViewCell.identifier)
        
        userAccessViewModel.userAccessDelegate = self
        
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
    @objc func testFunc() {
        self.setUpView()
    }
    
    func showSignInSheet() {
        let alert = UIAlertController(title: "Already a member?", message: "Please select an option to continue", preferredStyle: .actionSheet)
            
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
    
    func refreshUserDetails(_ preferredIndex: Int) {
        DispatchQueue.main.async {
            let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
            tabBarController.selectedIndex = preferredIndex
            self.dismiss(animated: true, completion: {})
        }
    }
    
    func showUserAccessController(_ isUserRegistration: Bool) {
        let storyboard: UIStoryboard = UIStoryboard(name: "ArticlesListViewController", bundle: Bundle(for: ArticlesListViewController.self))
        
        let userAccessViewController: UserAccessScreenViewController = storyboard.instantiateViewController(withIdentifier: "UserAccessScreenViewController") as!
        UserAccessScreenViewController
        
        userAccessViewController.isUserRegistration = isUserRegistration
        
        if let userAccessViewController = userAccessViewController.presentationController as? UISheetPresentationController {
            userAccessViewController.detents = [.large()]
        }
        
        self.present(userAccessViewController, animated: true, completion: nil)
    }
}
