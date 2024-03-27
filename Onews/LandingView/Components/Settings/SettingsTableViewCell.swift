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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        settingsImageView.layer.cornerRadius = 8.0
    }
    
    
    func setUpSettingsCell(using sfSymbol: String, backgroundColor: UIColor, label: String) {
        settingsImageView.image = UIImage(systemName: sfSymbol)
        settingsImageView.backgroundColor = backgroundColor
        settingsLabel.text = label
    }
}
