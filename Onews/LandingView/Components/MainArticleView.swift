//
//  MainArticleCollectionView+CollectionView.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/10/25.
//

import Foundation
import UIKit

class MainArticleView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var didSelectArticle: ((String) -> Void)?
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        addSubview(mainArticleCollectionView)
        
        mainArticleCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        mainArticleCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        mainArticleCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        mainArticleCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articlesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mainArticleCollectionView.dequeueReusableCell(withReuseIdentifier: "articleId", for: indexPath) as? MainArticleCollectionViewCell else { return UICollectionViewCell() }
      
        if !articlesArray.isEmpty {
            let article = articlesArray[indexPath.row]
            print("The Article is", article)
              
            downloadImg(urlString: article.urlToImage, imgView: cell.articleImg)
            
            cell.articleLabel.text = article.title
            cell.websiteLabel.text = article.source.name.uppercased()
            cell.websiteLabel.textColor = returnSourceColour()
            cell.timeLabel.text = Date().convertStringToDate(dateString: article.publishedAt)
            
            return cell
        } else {
            print("Array Empty :(")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 144.0) / 3, height: (UIScreen.main.bounds.width - 144.0) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectArticle?(ArticlesListViewModel.shared.articlesArray[indexPath.row].url)
    }
}

extension MainArticleView: ArticleDelegate {
    
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
    
    func reloadNewsArticles() {
        mainArticleCollectionView.reloadData()
    }
    
    func didReceiveArticlesSuccessfully() {
        mainArticleCollectionView.reloadData()
    }
    
    func didFailWithError(error: String) {
       print("Unable to retrieve")
    }
}
