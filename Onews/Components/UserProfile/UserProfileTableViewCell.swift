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
    @IBOutlet weak var lockImageView: UIImageView!
    
    @IBOutlet weak var faceIDLabel: UILabel!
    @IBOutlet weak var faceIDSubtitleLabel: UILabel!
    
    var isFaceIDVerified: Bool = false
    var userName: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.backgroundColor = .none
        print("XIB FaceID", self.isFaceIDVerified)
        print("XIB userName", self.userName)
        
        lockImageView.isHidden = !self.isFaceIDVerified
        faceIDLabel.isHidden = !self.isFaceIDVerified
        faceIDSubtitleLabel.isHidden = !self.isFaceIDVerified
    }
}
