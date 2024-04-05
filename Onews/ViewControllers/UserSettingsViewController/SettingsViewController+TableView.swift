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
        // TODO: Add a header & footer, describing what is happening, don't forget the states!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Array count is: \(self.userArticlesViewModel.articlesArray.count)")
        print("Array: \(self.userArticlesViewModel.articlesArray)")
        print("cellForRowAt Current State: \(self.currentState)")
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell") as? SettingsTableViewCell else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            print("CellForRow FaceID", self.isFaceIDVerified)
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileTableViewCell") as? UserProfileTableViewCell
            else { return UITableViewCell() }
            
            switch self.currentState {
                
            case .signedInWithFaceId, .signedInNoFaceId:
                cell.usernameLabel.text = self.userName ?? K.noSessionText
                cell.usernameLabel.isHidden = false
                cell.lockImageView.isHidden = true
                cell.faceIDLabel.isHidden = true
                cell.faceIDSubtitleLabel.isHidden = true
                
            case .verifyFaceIdFailed, .signingInWithFaceId:
                cell.usernameLabel.isHidden = true
                cell.lockImageView.isHidden = false
                cell.faceIDLabel.isHidden = false
                cell.faceIDSubtitleLabel.isHidden = false
                
            case .signedOut:
                cell.usernameLabel.text = K.noSessionText
                cell.usernameLabel.isHidden = false
                cell.lockImageView.isHidden = true
                cell.faceIDLabel.isHidden = true
                cell.faceIDSubtitleLabel.isHidden = true
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
            if self.isSignedIn {
                OnewsLoaderViewController.sharedInstance.setDisplay(loadingText: K.loadingUserSignedInText)
                OnewsLoaderViewController.sharedInstance.show()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    guard let self else { return }
                    self.hideNewsLoading()
                }
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
