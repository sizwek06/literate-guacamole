//
//  MainArticleCollectionView+CollectionView.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/10/25.
//

import Foundation
import UIKit

class MainArticleView: UIView {
    
    var didSelectArticle: ((String, String) -> Void)?
    var didShareArticle: ((String) -> Void)?
    var didSaveArticle: ((Article) -> Void)?
    var isSignedIn: Bool?
    
    var articlesArray: [Article] = [] {
        didSet {
            if articlesArray.count > 3 {
                return
            }
            mainArticleCollectionView.reloadData()
        }
    }
    
    lazy var mainArticleCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 20
        flowLayout.estimatedItemSize = CGSize(width: (UIScreen.main.bounds.width - 144.0) / 3, height: (UIScreen.main.bounds.width - 144.0) / 3)
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = true
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.register(UINib(nibName: "MainArticleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "articleId")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isUserInteractionEnabled = true
        return collectionView
    }()
    
    init(articlesArray: [Article], isSignedIn: Bool) {
        super.init(frame: .zero)
        self.articlesArray = articlesArray
        self.isSignedIn = isSignedIn
        setupView()
    }
    
    func setupView() {
        addSubview(mainArticleCollectionView)
        
        mainArticleCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        mainArticleCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        mainArticleCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        mainArticleCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        
        if UserDefaults.standard.bool(forKey: K.userDefaultSignedInKey) {
            if let user = UserDefaults.standard.string(forKey: K.userDefaultEmailKey) {
                self.isSignedIn = !user.isEmpty
            }
        }
    }
    
    func reload() {
        DispatchQueue.main.async {
            self.mainArticleCollectionView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func downloadImg(urlString: String?, imgView: UIImageView) {
        if let urlStr = urlString {
            let url = URL(string: urlStr)
            imgView.kf.indicatorType = .activity
            imgView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
        }
    }
    
    func returnSourceColour() -> UIColor {
        // TODO: Introduce source enums and map colours for
        // for e.g. you-tube = oNewsRed, tech-crunch = oNewsRed, default still black.
        let randomInt = Int.random(in: 1..<12)
        
        switch randomInt {
        case 0:
           return K.newsColor.oNewsBlue
        case 1..<3:
            return K.newsColor.oNewsGold
        case 4..<6:
            return K.newsColor.oNewsMaroon
        case 7..<9:
            return K.newsColor.oNewsGreen
        case 10..<12:
            return K.newsColor.oNewsOrange
        default:
            return K.newsColor.oNewsBlack
        }
    }
    
    func didReceiveArticlesSuccessfully() {
        mainArticleCollectionView.reloadData()
    }
    
    func didFailWithError(error: String) {
       print("Unable to retrieve")
    }
}
