//
//  MainArticleCollectionViewCell.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/23.
//

import Foundation
import UIKit
import OnewsSDK

class MainArticleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var articleImg: UIImageView!
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var articleShareButton: UIImageView!
    @IBOutlet weak var articleSaveButton: UIImageView!
    
    var didShareArticle: ((String) -> Void)?
    var didSaveArticle: ((Article) -> Void)?
    var currentArticle: Article?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        articleImg.layer.cornerRadius = 8.0
        articleImg.clipsToBounds = true
        
        view.backgroundColor = UIColor(named: "CollectionColor")
        view.layer.borderWidth = 0.3
        view.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        let tapShareGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(shareImageTapped(tapGestureRecognizer:)))
        articleShareButton.isUserInteractionEnabled = true
        articleShareButton.addGestureRecognizer(tapShareGestureRecognizer)
        
        let tapSaveGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(saveImageTapped(tapGestureRecognizer:)))
        articleSaveButton.isUserInteractionEnabled = true
        articleSaveButton.addGestureRecognizer(tapSaveGestureRecognizer)
    }
    
    @objc func shareImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        _ = tapGestureRecognizer.view as! UIImageView
        guard let article = currentArticle else { return }
        didShareArticle?(article.url)
    }
    
    @objc func saveImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        _ = tapGestureRecognizer.view as! UIImageView
        guard let article = currentArticle else { return }
        didSaveArticle?(article)
    }
    
    func setUpSaveImage() {
        let imageString = UserDefaults.standard.bool(forKey: K.userDefaultSignedInKey) ? "bookmark" : "bookmark.slash"
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .medium)
        
        let image = UIImage(systemName: imageString, withConfiguration: largeConfig)
        
        self.articleSaveButton.isUserInteractionEnabled = UserDefaults.standard.bool(forKey: K.userDefaultSignedInKey)
        self.articleSaveButton.image = image
    }
}
