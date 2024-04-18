//
//  RegionsViewController.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/04/06.
//

import Foundation
import UIKit

class RegionsViewController: SettingsViewController {
    
    override class func create() -> SettingsViewController {
        let regionsViewController = RegionsViewController()
        regionsViewController.userName = UserDefaults.standard.string(forKey: K.userDefaultEmailKey)
        return regionsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Regions"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupTableView()
    }
}

extension RegionsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "Select a region below to receive the latest top headlines from around the globe" : K.profileHeaderText
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? K.regionOptions.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileTableViewCell") as? UserProfileTableViewCell
            else { return UITableViewCell() }
            
            switch OnewsState.sharedInstance.currentState {
                
            case .signedInWithFaceId, .signedInNoFaceId:
                cell.usernameLabel.text = self.userName ?? "Choose one of the following \(K.regionOptions.count) countries!"
                cell.setUpProfileView(using: true)
                
            case .verifyFaceIdFailed, .signingInWithFaceId:
                cell.setUpProfileView(using: false)
                
            case .signedOut:
                cell.usernameLabel.text = "Choose one of the following \(K.regionOptions.count) countries!"
                cell.setUpProfileView(using: true)
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell") as? SettingsTableViewCell else { return UITableViewCell() }
            
            cell.settingsSwitch.isHidden = true
            cell.settingsImageView.isHidden = true
            
            if let currentRegion = UserDefaults.standard.string(forKey: K.userDefaultRegionKey) {
                if let selectedIndex = K.regionOptions.firstIndex(where: { $0.0 == currentRegion}) {
                    cell.accessoryType = indexPath.row == selectedIndex ? .checkmark : .none
                }
            }
            cell.settingsLabel.text = K.regionOptions[indexPath.row].value
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.bingBong()
        case 1:
            DispatchQueue.main.async {
                let country = K.regionOptions[indexPath.row].key
                
                UserDefaults.standard.setValue(country, forKey: K.userDefaultRegionKey)
            }
            self.dismiss(animated: true)
        default:
            break
        }
    }
}
