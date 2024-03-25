//
//  MainArticleCollectionViewCell.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/23.
//

import Foundation
import UIKit

class MainArticleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var articleImg: UIImageView!
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        articleImg.layer.cornerRadius = 8.0
        articleImg.clipsToBounds = true
        view.backgroundColor = UIColor(named: "CollectionColor")
        view.layer.borderWidth = 0.3
        view.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
    }
}
