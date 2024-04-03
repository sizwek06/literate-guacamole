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
    
    var switchOption: SettingsOptions!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        settingsImageView.layer.cornerRadius = 8.0
        self.selectionStyle = .none
        self.backgroundColor = .none
    }
    
    @IBAction func switchOn(_ sender: UISwitch) {
        
        switch switchOption {
        case .faceID:
            UserDefaults.standard.set(sender.isOn, forKey: K.userDefaultBiometricsKey)
            print("FaceID set on")
        case .notifications:
            UserDefaults.standard.set(sender.isOn, forKey: K.userDefaultNotificationsKey)
            print("Notifications set on")
        case .none:
            break
        }
    }
    
    func setUpSettingsCell(using sfSymbol: String, backgroundColor: UIColor,
                           label: String, switchState: Bool) {
        
        settingsSwitch.isOn = switchState
        settingsImageView.image = UIImage(systemName: sfSymbol)
        settingsImageView.backgroundColor = backgroundColor
        settingsLabel.text = label
    }
}

enum SettingsOptions {
    case notifications
    case faceID
}
