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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
            
            cell.signOutLabel.font = UIFont(name: "SF-Pro-Display-Bold", size: 15)
            
            cell.signOutLabel.text = isSignedIn ? K.signOutText : K.signInText
            cell.signOutLabel.textColor = isSignedIn ? .red : .systemBlue
        
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            showSignInSheet()
        } else {
            showSignInSheet()
        }
    }
}
