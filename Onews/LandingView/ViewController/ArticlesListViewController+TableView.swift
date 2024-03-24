//
//  LandingViewController+TableView.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/03/16.
//

import Foundation
import UIKit

extension ArticlesListViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        return section == 0 ? 1 : articlesListViewModel.articlesArray.count
    }

    // From Gugs
    // MainArticle needs section headerView. (code in chat with Gugs 03 Apr)
    // Tesla News is a headerInSection, hide...
    // consider footerInSection to have Load More (paging)
    // group via sources/genre
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 515 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let article = articlesListViewModel.articlesArray[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsArticle", for: indexPath) as! NewsArticleTableViewCell
            
            cell.selectionStyle = .none
            cell.backgroundColor = .none
            
            downloadImg(urlString: article.urlToImage, imgView: cell.articleImg)
            
            cell.articleLabel.text = article.title
            cell.websiteLabel.text = article.source.name.uppercased()
            cell.websiteLabel.textColor = returnSourceColour()
            cell.timeLabel.text = Date().convertStringToDate(dateString: article.publishedAt)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainArticleTableViewCell.identifier) as? MainArticleTableViewCell else { return UITableViewCell() }
            
            cell.mainArticleView.articlesArray = Array(articlesListViewModel.articlesArray.prefix(3))
            
            cell.mainArticleView.didSelectArticle = { articleClicked, articleSource in
                self.handleOpenArticleURL(url: articleClicked, source: articleSource)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articlesListViewModel.articlesArray[indexPath.row]
        
        DispatchQueue.main.async {
            self.handleOpenArticleURL(url: article.url, source: article.source.name)
        }
    }
}
