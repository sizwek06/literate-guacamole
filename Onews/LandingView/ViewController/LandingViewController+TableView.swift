//
//  LandingViewController+TableView.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/03/16.
//

import Foundation
import UIKit

extension LandingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? K.mainArticleHeader : K.otherArticlesHeader
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : LandingViewModel.shared.articlesArray.count
    }

    //From Gugs
    //MainArticle needs section headerView. (code in chat with Gugs 03 Apr)
    //Tesla News is a headerInSection, hide...
    //consider footerInSection to have Load More (paging)
    //group via sources/genre
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let article = LandingViewModel.shared.articlesArray[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsArticle", for: indexPath) as! NewsArticleTableViewCell
            
            cell.selectionStyle = .none
            cell.backgroundColor = .none
            
            downloadImg(urlString: article.urlToImage, imgView: cell.articleImg)
            cell.articleImg.layer.cornerRadius = 8.0
            cell.articleImg.clipsToBounds = true
            
            cell.articleLabel.text = article.title
            cell.websiteLabel.text = article.source.name
            cell.websiteLabel.textColor = returnSourceColour()
            cell.timeLabel.text = Date().convertStringToDate(dateString: article.publishedAt)
            
            return cell
        } else {
            guard let mainArticle = LandingViewModel.shared.mainArticle else { return UITableViewCell() }

            let cell = tableView.dequeueReusableCell(withIdentifier: "mainArticle", for: indexPath) as! MainArticleTableViewCell

            cell.selectionStyle = .none
            cell.backgroundColor = .none

            downloadImg(urlString: mainArticle.urlToImage, imgView: cell.articleImg)
            cell.articleLabel.text = mainArticle.title
            cell.websiteLabel.text = mainArticle.source.name
            cell.websiteLabel.textColor = returnSourceColour()
            cell.timeLabel.text = Date().convertStringToDate(dateString: mainArticle.publishedAt)

            return cell
        }
    }
}
