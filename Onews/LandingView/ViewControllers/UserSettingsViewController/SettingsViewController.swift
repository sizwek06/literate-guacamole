//
//  SettingsViewController.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/27.
//

import Foundation
import UIKit

class SettingsViewController: ArticlesListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        super.tableView.register(UINib(nibName: "UserProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "userProfileTableViewCell")
        super.tableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "settingsCell")
        super.tableView.register(SingleLabelTableViewCell.self, forCellReuseIdentifier: SingleLabelTableViewCell.identifier)
        
        tableView.frame = view.bounds
        super.search.searchBar.isHidden = true
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
}

// MARK: - TableView Content
extension SettingsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 180 : 54
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileTableViewCell", for: indexPath) as? UserProfileTableViewCell 
            else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.backgroundColor = .none

            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell") as? SettingsTableViewCell else { return UITableViewCell() }
            
           indexPath.row == 0 ? cell.setUpSettingsCell(using: "bell.badge.fill", backgroundColor: UIColor.red, label: "Notification")
            : cell.setUpSettingsCell(using: "faceid", backgroundColor: UIColor.systemGreen, label: "FaceID")
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SingleLabelTableViewCell.identifier) as? SingleLabelTableViewCell 
            else { return UITableViewCell() }
            
            cell.signOutLabel.text = K.signOutText
            cell.signOutLabel.font = UIFont(name: "SF-Pro-Display-Bold", size: 15)
            cell.signOutLabel.textColor = .red
            
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        let swipeConfiguration = UISwipeActionsConfiguration()
        return swipeConfiguration
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeConfiguration = UISwipeActionsConfiguration()
        return swipeConfiguration
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            showUserAccessController()
        } else {
            showUserAccessController()
        }
    }
}
