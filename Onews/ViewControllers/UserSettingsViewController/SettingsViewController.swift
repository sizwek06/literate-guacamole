//
//  SettingsViewController.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/27.
//

import Foundation
import UIKit
import FirebaseAuth

class SettingsViewController: BaseTableViewController {
    
    class func create() -> SettingsViewController {
        print("SettingsViewController created.")
        let settingsViewController = SettingsViewController()
        settingsViewController.userAccessViewModel = UserAccessViewModel(userAccessDelegate: settingsViewController)
        settingsViewController.userName = UserDefaults.standard.string(forKey: K.userDefaultEmailKey)
        return settingsViewController
    }
    
    var userName: String?
    var userAccessViewModel: UserAccessViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = K.settingsViewTitle
        super.tableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "settingsCell")
        tableView.isScrollEnabled = false
        
        verifyUser()
        self.setupTableView()
        print("SettingsViewController - Current Super State \(OnewsState.sharedInstance.currentState)")
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
        
        guard let userAccessViewController = UserAccessScreenViewController.create() else {
            return
        }
       
        userAccessViewController.isUserRegistration = isUserRegistration
        
        if let userAccessViewController = userAccessViewController.presentationController as? UISheetPresentationController {
            userAccessViewController.detents = [.large()]
        }
        
        self.present(userAccessViewController, animated: true, completion: nil)
    }
}
