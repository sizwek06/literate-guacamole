//
//  LandingViewController+TableView.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/03/16.
//

import Foundation
import UIKit

extension ArticlesListViewController {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? K.mainArticleHeader : K.otherArticlesHeader
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : articlesListViewModel.articlesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
            
            cell.mainArticleView.didSaveArticle = { article in
                self.articlesListViewModel.saveNewsArticle(using: article)
            }
            
            cell.mainArticleView.didShareArticle = { articleSource in
                self.shareArticleLink(with: articleSource)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articlesListViewModel.articlesArray[indexPath.row]
        
        if indexPath.section == 1 {
            self.handleOpenArticleURL(url: article.url, source: article.source.name)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 1 {
            let shareAction = UIContextualAction(style: .normal, title: nil) {_, _, completionHandler in
                self.shareArticleLink(with: self.articlesListViewModel.articlesArray[indexPath.row].url)
                
                completionHandler(true)
            }
            
            let likeAction = UIContextualAction(style: .normal, title: nil) {_, _, completionHandler in
                self.articlesListViewModel.saveNewsArticle(using: self.articlesListViewModel.articlesArray[indexPath.row])
                
                completionHandler(true)
            }
            
            shareAction.backgroundColor = K.newsColor.oNewsBlue
            likeAction.backgroundColor = K.newsColor.oNewsMaroon
            
            let swipeConfiguration = UISwipeActionsConfiguration(actions: [likeAction, shareAction])
            swipeConfiguration.performsFirstActionWithFullSwipe = false
            
            likeAction.image = addLabelToImage(imageString: "bookmark", labelString: "Save")
            shareAction.image = addLabelToImage(imageString: "square.and.arrow.up", labelString: "Share")
            
            return swipeConfiguration
        } else {
            let swipeConfiguration = UISwipeActionsConfiguration()
            return swipeConfiguration
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1 {
            let removeAction = UIContextualAction(style: .destructive, title: nil) {_, _, completionHandler in
                self.articlesListViewModel.articlesArray.remove(at: indexPath.row)
                
                self.didReceiveArticlesSuccessfully()
                completionHandler(true)
            }
            removeAction.backgroundColor = .systemBlue
            
            let swipeConfiguration = UISwipeActionsConfiguration(actions: [removeAction])
            swipeConfiguration.performsFirstActionWithFullSwipe = true
            
            removeAction.image = addLabelToImage(imageString: "envelope.open", labelString: "Read")
            
            return swipeConfiguration
        } else {
            let swipeConfiguration = UISwipeActionsConfiguration()
            return swipeConfiguration
        }
    }
}
