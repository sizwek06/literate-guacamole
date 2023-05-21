//
//  LandingViewController+TableView.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/03/16.
//

import Foundation
import UIKit

extension LandingViewController {
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return 0
//        } else {
//            print(LandingViewModel.shared.articlesArray.count)
//            return LandingViewModel.shared.articlesArray.count
//        }
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LandingViewModel.shared.articlesArray.count
    }
//
    //From Gugs
    //MainArticle needs section headerView. (code in chat with Gugs 03 Apr)
    //Tesla News is a headerInSection, hide...
    //consider footerInSection to have Load More (paging)
    //group via sources/genre
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            let article = LandingViewModel.shared.articlesArray[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsArticle", for: indexPath) as! NewsArticleTableViewCell
            
            cell.selectionStyle = .none
            cell.backgroundColor = .none
            
            downloadImg(urlString: article.articleImgURL, imgView: cell.articleImg)
            cell.articleImg.layer.cornerRadius = 8.0
            cell.articleImg.clipsToBounds = true
            
            cell.articleLabel.text = article.articleTitle
            cell.websiteLabel.text = article.articleSource.name
            cell.timeLabel.text = Date().convertStringToDate(dateString: article.publishedDate!)
            
            return cell
        } else {
            let mainArticle = LandingViewModel.shared.articlesArray[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainArticle", for: indexPath) as! MainArticleTableViewCell
            
            cell.selectionStyle = .none
            cell.backgroundColor = .none
            
//            downloadImg(urlString: mainArticle.articleImgURL, imgView: cell.articleImg)
            cell.articleLabel.text = mainArticle.articleTitle
            cell.websiteLabel.text = mainArticle.articleSource.name
//            cell.timeLabel.text = mainArticle.publishedDate.asString()
            
            return cell
        }
    }
}
