//
//  SettingsTableViewCell.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/27.
//

import Foundation
import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var settingsImageView: UIImageView!
    @IBOutlet weak var settingsSwitch: UISwitch!
    @IBOutlet weak var settingsLabel: UILabel!
    
    var switchOption: SettingsOptions?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        settingsImageView.layer.cornerRadius = 8.0
        self.selectionStyle = .none
        self.backgroundColor = .none
        
        self.settingsLabel.textColor = UIColor(named: "AppearanceColor")
    }
    
    @IBAction func switchOn(_ sender: UISwitch) {
        
        guard let switchOption = switchOption else { return }
        
        switch switchOption {
        case .faceID:
            UserDefaults.standard.setValue(sender.isOn, forKey: K.userDefaultBiometricsKey)
            OnewsState.sharedInstance.currentState = sender.isOn ? .faceIDRequired : .signedInNoFaceId
            // TODO: Kick off FaceID verification when this is on.
        case .notifications:
            UserDefaults.standard.setValue(sender.isOn, forKey: K.userDefaultNotificationsKey)
        case .region:
            break
        }
    }
    
    func setUpSettingsCell() {
        guard let switchOption = switchOption else { return }
        
        settingsLabel.text = switchOption.settingsLabelText
        
        switch switchOption {
        case .notifications:
            settingsSwitch.isOn = UserDefaults.standard.bool(forKey: K.userDefaultNotificationsKey)
            
            self.settingsLabel.textColor = UIColor(named: "AppearanceColor")
            settingsImageView.image = UIImage(systemName: "bell.badge.fill")
            self.switchOption = .notifications
            settingsImageView.backgroundColor = UIColor.red
            self.settingsSwitch.isHidden = false
            self.settingsSwitch.isEnabled = true
            
        case .faceID:
            settingsSwitch.isOn = UserDefaults.standard.bool(forKey: K.userDefaultBiometricsKey)
            
            switch OnewsState.sharedInstance.currentState {
            case .verifyFaceIdFailed, .signingInWithFaceId, .faceIDRequired, .signedOut:
                self.settingsSwitch.isEnabled = false
                self.settingsLabel.textColor = .gray
            default:
                self.settingsSwitch.isEnabled = true
            }
            
            settingsImageView.image = UIImage(systemName: "faceid")
            self.switchOption = .faceID
            settingsImageView.backgroundColor = UIColor.systemGreen
            self.accessoryType = .none
            self.settingsSwitch.isHidden = false
            
        case .region:
            settingsImageView.backgroundColor = UIColor.systemMint
            self.accessoryType = .disclosureIndicator
            self.settingsSwitch.isHidden = true
            self.switchOption = .region
            
            switch OnewsState.sharedInstance.currentState {
            case .verifyFaceIdFailed, .faceIDRequired, .signingInWithFaceId:
                self.isUserInteractionEnabled = false
                self.settingsLabel.textColor = .gray
            default:
                self.isUserInteractionEnabled = true
            }
        }
    }
}

enum SettingsOptions {
    case notifications
    case faceID
    case region
    
    var settingsLabelText: String {
        switch self {
        case .notifications: return "Notifications"
        case .faceID: return "FaceID"
        case .region: return "Change Region"
        }
    }
}
