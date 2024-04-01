//
//  SettingsViewController+TableView.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/27.
//

import Foundation
import UIKit

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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileTableViewCell", for: indexPath) as? UserProfileTableViewCell
            else { return UITableViewCell() }
            
            cell.usernameLabel.text = self.userName

            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell") as? SettingsTableViewCell else { return UITableViewCell() }
                
                if indexPath.row == 0 {
                    cell.setUpSettingsCell(using: "bell.badge.fill",
                                           backgroundColor: UIColor.red,
                                           label: "Notifications",
                                           switchState: UserDefaults.standard.bool(forKey: K.userDefaultNotificationsKey))
                    cell.switchOption = .notifications
                } else {
                    cell.setUpSettingsCell(using: "faceid",
                                           backgroundColor: UIColor.systemGreen,
                                           label: "FaceID",
                                           switchState: UserDefaults.standard.bool(forKey: K.userDefaultBiometricsKey))
                    cell.switchOption = .faceID
                }
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SingleLabelTableViewCell.identifier) as? SingleLabelTableViewCell
            else { return UITableViewCell() }
            
            cell.signOutLabel.font = UIFont(name: "SF-Pro-Display-Bold", size: 15)
            
            cell.signOutLabel.text = isSignedIn ? K.signOutText : K.signInText
            cell.signOutLabel.textColor = isSignedIn ? .red : .systemBlue
        
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            isSignedIn ? confirmLogOut() : showSignInSheet()
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeConfiguration = UISwipeActionsConfiguration()
        return swipeConfiguration
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeConfiguration = UISwipeActionsConfiguration()
        return swipeConfiguration
    }
}
