//
//  UserProfileTableViewCell.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/26.
//

import Foundation
import UIKit

class UserProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userProfileButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.usernameLabel.text = "@sizwe44"
        
        self.selectionStyle = .none
        self.backgroundColor = .none
    }
}
