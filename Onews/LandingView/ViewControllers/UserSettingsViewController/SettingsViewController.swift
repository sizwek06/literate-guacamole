//
//  SettingsViewController.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/27.
//

import Foundation
import UIKit

class SettingsViewController: BaseTableViewController {
    
    var isSignedIn = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        super.tableView.register(UINib(nibName: "UserProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "userProfileTableViewCell")
        super.tableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "settingsCell")
        super.tableView.register(SingleLabelTableViewCell.self, forCellReuseIdentifier: SingleLabelTableViewCell.identifier)
        
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
    func showUserAccessController() {
        let storyboard = UIStoryboard(name: "ArticlesListViewController", bundle: Bundle(for: ArticlesListViewController.self))
        
        let userAccessViewController = storyboard.instantiateViewController(withIdentifier: "UserAccessScreenViewController")
        
        if let userAccessViewController = userAccessViewController.presentationController as? UISheetPresentationController {
            userAccessViewController.detents = [.large()]
        }
        
        self.present(userAccessViewController, animated: true, completion: nil)
    }
    
    func showSignInSheet() {
        let alert = UIAlertController(title: nil, message: "Please Select an Option to continue", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Register", style: .default, handler: { (UIAlertAction) in
                self.showUserAccessController()
            }))

            alert.addAction(UIAlertAction(title: "Sign In", style: .default, handler: { (UIAlertAction) in
                self.showSignInSheet()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
                alert.dismiss(animated: true)
            }))
        
        self.present(alert, animated: true)
    }
}
