//
//  NewsArticleTableViewCell.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/03/20.
//

import Foundation
import UIKit

class NewsArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var articleImg: UIImageView!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        articleImg.layer.cornerRadius = 8.0
        articleImg.clipsToBounds = true
    }
}
