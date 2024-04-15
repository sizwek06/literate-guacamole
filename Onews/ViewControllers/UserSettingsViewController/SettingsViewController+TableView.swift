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
        if section == 0 {
            switch self.currentState {
            case .signingInWithFaceId, .signedOut, .verifyFaceIdFailed:
                return ""
            default:
                return K.profileHeaderText
            }
        } else {
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return section == 1 ? K.settingsFooterText : ""
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? 3 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell") as? SettingsTableViewCell else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileTableViewCell") as? UserProfileTableViewCell
            else { return UITableViewCell() }
            
            switch self.currentState {
                
            case .signedInWithFaceId, .signedInNoFaceId:
                cell.usernameLabel.text = self.userName ?? K.noSessionText
                cell.setUpProfileView(using: true)
                
            case .verifyFaceIdFailed, .signingInWithFaceId:
                cell.setUpProfileView(using: false)
                
            case .signedOut:
                cell.usernameLabel.text = K.noSessionText
                cell.setUpProfileView(using: true)
            }
            return cell
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
                cell.accessoryType = .none
                cell.settingsSwitch.isHidden = false
                
                switch self.currentState {
                case .verifyFaceIdFailed, .signingInWithFaceId, .signedOut:
                    cell.settingsSwitch.isEnabled = false
                    cell.settingsLabel.textColor = .gray
                default:
                    cell.settingsSwitch.isEnabled = true
                    cell.settingsLabel.textColor = .black
                }
                
                return cell
            case 2:
                cell.setUpSettingsCell(using: "globe.europe.africa.fill",
                                       backgroundColor: UIColor.systemMint,
                                       label: "Change Region")
                cell.switchOption = .region
                cell.accessoryType = .disclosureIndicator
                cell.settingsSwitch.isHidden = true
                
                switch self.currentState {
                case .verifyFaceIdFailed, .signingInWithFaceId:
                    cell.isUserInteractionEnabled = false
                    cell.settingsLabel.textColor = .gray
                default:
                    cell.isUserInteractionEnabled = true
                    cell.settingsLabel.textColor = .black
                }
//            TODO: FIX STATE AFTER SIGNED OUT
                return cell
            default:
                return UITableViewCell()
            }
        case 2:
            switch self.currentState {
            case .signedInNoFaceId, .signingInWithFaceId:
                return createSignOutView()
            case .signedOut:
                return createSignOutView()
            case .signedInWithFaceId, .verifyFaceIdFailed:
                return createUseFaceIdView()
            }
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch self.currentState {
                case .signedInNoFaceId, .signedInWithFaceId:
                    self.bingBong()
                default:
                    break
                }
        case 1:
            switch indexPath.row {
            case 2:
                let regionsViewController = RegionsViewController()
                let navController = UINavigationController(rootViewController: regionsViewController)
                navController.navigationBar.barTintColor = UIColor(named: "CollectionColor")
                
                self.present(navController, animated: true)
            default:
                break
            }
        case 2:
            switch self.currentState {
            case .signedInNoFaceId, .signingInWithFaceId:
                return confirmLogOut()
            case .signedOut:
                return showSignInSheet()
            case .signedInWithFaceId, .verifyFaceIdFailed:
                return verifyUser()
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
        
        switch self.currentState {
        case .signedInNoFaceId, .signedInWithFaceId:
            cell.signOutLabel.text = K.signOutText
            cell.signOutLabel.textColor = .red
        case  .signedOut:
            cell.signOutLabel.text = K.signInText
            cell.signOutLabel.textColor = .systemBlue
        default:
            return UITableViewCell()
        }
        
        return cell
    }
}
