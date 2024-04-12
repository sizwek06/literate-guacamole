//
//  MainArticleView+CollectionView.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/31.
//

import Foundation
import UIKit

extension MainArticleView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articlesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mainArticleCollectionView.dequeueReusableCell(withReuseIdentifier: "articleId", for: indexPath) as? MainArticleCollectionViewCell else { return UICollectionViewCell() }
      
        if !articlesArray.isEmpty {
            let article = articlesArray[indexPath.row]
              
            downloadImg(urlString: article.urlToImage, imgView: cell.articleImg)
            cell.currentArticle = article
            cell.articleLabel.text = article.title
            cell.websiteLabel.text = (article.source.name ?? K.newsViewHeader).uppercased()
            cell.websiteLabel.textColor = returnSourceColour()
            cell.timeLabel.text = Date().convertStringToDate(dateString: article.publishedAt)
            
            if let userSignedIn = self.isSignedIn {
                cell.setUpSaveImage(using: userSignedIn)
            }
            
            cell.didSaveArticle = { article in
                self.didSaveArticle?(article)
            }
            
            cell.didShareArticle = { currentURL in
                self.didShareArticle?(currentURL)
            }
            
            return cell
        } else {
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 144.0) / 3, height: (UIScreen.main.bounds.width - 144.0) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectArticle?(articlesArray[indexPath.row].url, articlesArray[indexPath.row].source.name ?? K.newsViewHeader)
    }
}
