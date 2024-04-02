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

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell") as? SettingsTableViewCell else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            return createProfileView()
        case 1:
            switch indexPath.row {
            case 0:
                cell.setUpSettingsCell(using: "bell.badge.fill",
                                       backgroundColor: UIColor.red,
                                       label: "Notifications",
                                       switchState: UserDefaults.standard.bool(forKey: K.userDefaultNotificationsKey))
                cell.switchOption = .notifications
                
                return cell
            case 1:
                cell.setUpSettingsCell(using: "faceid",
                                       backgroundColor: UIColor.systemGreen,
                                       label: "FaceID",
                                       switchState: UserDefaults.standard.bool(forKey: K.userDefaultBiometricsKey))
                cell.switchOption = .faceID
                
                return cell
            default:
                return UITableViewCell()
            }
        case 2:
            return isSignedIn ? createSignOutView() : createNoSignInTableViewCell()
        default:
            break
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if self.isSignedIn {
                OnewsLoaderViewController.sharedInstance.setDisplay(loadingText: K.loadingUserSignedInText)
                OnewsLoaderViewController.sharedInstance.show()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    guard let self else { return }
                    self.hideNewsLoading()
                }
            }
        case 2:
            if self.isSignedIn {
                self.confirmLogOut()
            } else if self.isSignedIn && !self.isFaceIDVerified {
                self.verifyUser()
            } else {
                self.showSignInSheet()
            }
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
    
    func createSignOutView() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SingleLabelTableViewCell.identifier) as? SingleLabelTableViewCell
        else { return UITableViewCell() }
        
        cell.signOutLabel.font = UIFont(name: "SF-Pro-Display-Bold", size: 15)
        
        cell.signOutLabel.text = self.isSignedIn ? K.signOutText : K.signInText
        cell.signOutLabel.textColor = self.isSignedIn ? .red : .systemBlue
        
        return cell
    }
}
