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
    
    var currentState: OnewsStates = .signingInWithFaceId
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.backgroundColor = .none
    }
    
    func setUpProfileView(using isShown: Bool) {
        self.usernameLabel.isHidden = !isShown
        self.lockImageView.isHidden = isShown
        self.faceIDLabel.isHidden = isShown
        self.faceIDSubtitleLabel.isHidden = isShown
    }
}
