//
//  UserViewController+TableView.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/26.
//

import Foundation
import UIKit

extension UserViewController {
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         return section == 0 ? "" : (self.isSignedIn ? "Articles" : "")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.isSignedIn ? self.articlesArray.count : 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 180 : UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            if self.isSignedIn {
                let article = self.articlesArray[indexPath.row]
                
                return createArticleTableViewCell(with: article)
            } else {
                return createNoSignInTableViewCell()
            }
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileTableViewCell", for: indexPath) as? UserProfileTableViewCell else { return UITableViewCell() }
            cell.usernameLabel.text = self.userName
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // TODO: Maybe show loader with icon bouncing and about text?
        } else {
            if isSignedIn {
                let article = articlesArray[indexPath.row]
                
                DispatchQueue.main.async {
                    self.handleOpenArticleURL(url: article.url, source: article.source.name)
                }
            } else {
                    self.navigateToSettingsSignIn()
                }
            }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print("Array count is: \(self.articlesArray.count)")
        
        if indexPath.section == 1 && isSignedIn {
            let shareAction = UIContextualAction(style: .normal, title: nil) {_, _, completionHandler in
                self.shareArticleLink(with: self.articlesArray[indexPath.row].url)
                
                completionHandler(true)
            }
            
            shareAction.backgroundColor = K.newsColor.oNewsBlue
            
            let swipeConfiguration = UISwipeActionsConfiguration(actions: [shareAction])
            swipeConfiguration.performsFirstActionWithFullSwipe = true
            
            shareAction.image = addLabelToImage(imageString: "square.and.arrow.up", labelString: "Share")
            
            return swipeConfiguration
        } else {
            let swipeConfiguration = UISwipeActionsConfiguration()
            return swipeConfiguration
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1 && isSignedIn {
            let removeAction = UIContextualAction(style: .destructive, title: nil) {_, _, completionHandler in
                
                self.articlesArray.remove(at: indexPath.row)
                
                completionHandler(true)
            }
            removeAction.backgroundColor = .systemRed
            
            let swipeConfiguration = UISwipeActionsConfiguration(actions: [removeAction])
            swipeConfiguration.performsFirstActionWithFullSwipe = true
            
            removeAction.image = addLabelToImage(imageString: "trash.fill", labelString: "Delete")
            
            tableView.reloadData()
            
            return swipeConfiguration
        } else {
            let swipeConfiguration = UISwipeActionsConfiguration()
            return swipeConfiguration
        }
    }
    
    func createNoSignInTableViewCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SingleLabelTableViewCell.identifier) as? SingleLabelTableViewCell
        else { return UITableViewCell() }
        
        cell.signOutLabel.font = UIFont(name: "SF-Pro-Display-Bold", size: 15)
        
        cell.signOutLabel.text = K.signInText
        cell.signOutLabel.textColor = .systemBlue
        
        return cell
    }
    
    func createArticleTableViewCell(with article: Article) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsArticle") as? NewsArticleTableViewCell
        else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.backgroundColor = .none
        
        downloadImg(urlString: article.urlToImage, imgView: cell.articleImg)
        
        cell.articleLabel.text = article.title
        cell.websiteLabel.text = article.source.name.uppercased()
        cell.websiteLabel.textColor = returnSourceColour()
        cell.timeLabel.text = Date().convertStringToDate(dateString: article.publishedAt)
        
        return cell
    }
}
