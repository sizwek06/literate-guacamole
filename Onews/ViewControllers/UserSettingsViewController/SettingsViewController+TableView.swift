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
        if section == 0 {
            switch OnewsState.sharedInstance.currentState {
            case .signingInWithFaceId, .signedOut, .verifyFaceIdFailed, .faceIDRequired:
                return ""
            default:
                return K.profileHeaderText
            }
        } else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return section == 1 ? K.settingsFooterText : ""
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? 3 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileTableViewCell") as? UserProfileTableViewCell
            else { return UITableViewCell() }
            
            switch OnewsState.sharedInstance.currentState {
                
            case .signedInWithFaceId, .signedInNoFaceId:
                cell.usernameLabel.text = self.userName ?? K.noSessionText
                cell.setUpProfileView(using: true)
                
            case .verifyFaceIdFailed, .signingInWithFaceId, .faceIDRequired:
                cell.setUpProfileView(using: false)
                
            case .signedOut:
                cell.usernameLabel.text = K.noSessionText
                cell.setUpProfileView(using: true)
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell") as? SettingsTableViewCell else { return UITableViewCell() }
            
            switch indexPath.row {
            case 0:
                cell.switchOption = .notifications
                cell.setUpSettingsCell()
                return cell
            case 1:
                cell.switchOption = .faceID
                cell.setUpSettingsCell()
                return cell
            case 2:
                cell.switchOption = .region
                cell.setUpSettingsCell()
                return cell
            default:
                return UITableViewCell()
            }
        case 2:
            switch OnewsState.sharedInstance.currentState {
            case .signedInNoFaceId, .signingInWithFaceId, .signedInWithFaceId, .signedOut:
                return createSignOutView()
            case .verifyFaceIdFailed, .faceIDRequired:
                return createUseFaceIdView()
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch OnewsState.sharedInstance.currentState {
            case .signedInNoFaceId, .signedInWithFaceId:
                self.bingBong()
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 2:
                let regionsViewController = RegionsViewController.create()
                regionsViewController.userAccessViewModel = UserAccessViewModel(userAccessDelegate: regionsViewController)
                let navController = UINavigationController(rootViewController: regionsViewController)
                navController.navigationBar.barTintColor = UIColor(named: "CollectionColor")
                
                self.present(navController, animated: true)
            default:
                break
            }
        case 2:
            switch OnewsState.sharedInstance.currentState {
            case .signedInWithFaceId, .signedInNoFaceId, .signingInWithFaceId:
                confirmLogOut()
            case .signedOut:
                showSignInSheet()
            case .verifyFaceIdFailed, .faceIDRequired:
                OnewsState.sharedInstance.currentState = .verifyFaceIdFailed
                self.refreshUserDetails(0)
            }
        default:
            break
        }
    }
    
    func createSignOutView() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SingleLabelTableViewCell.identifier) as? SingleLabelTableViewCell
        else { return UITableViewCell() }
        
        cell.signOutLabel.font = UIFont(name: "SF-Pro-Display-Bold", size: 15)
        
        switch OnewsState.sharedInstance.currentState {
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
