//
//  UserViewController+TableView.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/26.
//

import Foundation
import UIKit
import OnewsSDK

extension ProfileViewController {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            switch self.currentState {
            case .signingInWithFaceId, .signedOut, .verifyFaceIdFailed:
                return ""
            default:
                return "Articles"
            }
        } else {
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            switch self.currentState {
            case .signedInWithFaceId:
                if self.isFaceIDVerified {
                    return checkRowCount()
                }
            case .signedInNoFaceId:
                return checkRowCount()
            default:
                return 1
            }
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 180 : UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            switch self.currentState {
            
            case .signingInWithFaceId, .verifyFaceIdFailed:
                return createUseFaceIdView()
            case .signedInNoFaceId, .signedInWithFaceId:
                return createNewsArticleSection(indexPathRow: indexPath.row)
            case .signedOut:
                return createNotSignInTableViewCell()
            }
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileTableViewCell") as? UserProfileTableViewCell
            else { return UITableViewCell() }
            
            switch self.currentState {

                case .signedInWithFaceId, .signedInNoFaceId:
                cell.usernameLabel.text = self.userName ?? K.noSessionText
                    cell.setUpProfileView(using: true)

                case .verifyFaceIdFailed, .signingInWithFaceId:
                    cell.setUpProfileView(using: false)
            
                case .signedOut:
                    cell.usernameLabel.text = K.noSessionText
                    cell.setUpProfileView(using: true)
                }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch self.currentState {
            case .signedInNoFaceId, .signedInWithFaceId:
                self.bingBong()
            default:
                self.navigateToSettingsSignIn()
            }
        } else {
            switch self.currentState {
                
            case .signedInNoFaceId, .signedInWithFaceId:
                if self.isSignedIn && self.userArticlesViewModel.articlesArray.isEmpty {
                    self.navigateToArticles()
                } else if !self.userArticlesViewModel.articlesArray.isEmpty {
                    let article = userArticlesViewModel.articlesArray[indexPath.row]
                    
                    DispatchQueue.main.async {
                        self.handleOpenArticleURL(url: article.url, source: article.source.name ?? "No name")
                    }
                }
            case .verifyFaceIdFailed, .signingInWithFaceId:
                self.verifyUser()
            case .signedOut:
                self.navigateToSettingsSignIn()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 1 && isSignedIn {
            let shareAction = UIContextualAction(style: .normal, title: nil) {_, _, completionHandler in
                self.shareArticleLink(with: self.userArticlesViewModel.articlesArray[indexPath.row].url)
                
                completionHandler(true)
            }
            
            shareAction.backgroundColor = K.newsColor.oNewsBlue
            
            let swipeConfiguration = UISwipeActionsConfiguration(actions: [shareAction])
            swipeConfiguration.performsFirstActionWithFullSwipe = true
            
            shareAction.image = addLabelToImage(imageString: "square.and.arrow.up", labelString: "Share")
            
            self.setUpView()
            
            return swipeConfiguration
        } else {
            let swipeConfiguration = UISwipeActionsConfiguration()
            return swipeConfiguration
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let currentArticle = self.userArticlesViewModel.articlesArray[indexPath.row]
        
        if indexPath.section == 1 && isSignedIn {
            let removeAction = UIContextualAction(style: .destructive, title: nil) {_, _, completionHandler in
                
                guard let uuid = UserDefaults.standard.string(forKey: K.userDefaultUUIDKey) else { return }
                
                self.userArticlesViewModel.deleteUserArticles(using: currentArticle.url,
                                                              uuid: uuid)
                
                if UserDefaults.standard.bool(forKey: K.userDefaultNotificationsKey) {
                    self.sendArticleNotification(using: currentArticle, 
                                                 isSaved: false)
                }
                
                completionHandler(true)
            }
            removeAction.backgroundColor = .systemRed
            
            let swipeConfiguration = UISwipeActionsConfiguration(actions: [removeAction])
            swipeConfiguration.performsFirstActionWithFullSwipe = true
            
            removeAction.image = addLabelToImage(imageString: "trash.fill", labelString: "Delete")
            
            return swipeConfiguration
        } else {
            let swipeConfiguration = UISwipeActionsConfiguration()
            return swipeConfiguration
        }
    }
    
    func createNotSignInTableViewCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SingleLabelTableViewCell.identifier) as? SingleLabelTableViewCell
        else { return UITableViewCell() }

        cell.signOutLabel.text = UserDefaults.standard.bool(forKey: K.userDefaultSignedInKey) ? K.getMoreArticlesText: K.signInText
        cell.signOutLabel.textColor = UserDefaults.standard.bool(forKey: K.userDefaultSignedInKey) ? .black : .systemBlue
        
        return cell
    }
    
    func createUseFaceIdView() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserFaceIDTableViewCell.identifier) as? UserFaceIDTableViewCell
        else { return UITableViewCell() }

        return cell
    }
    
    func createArticleTableViewCell(with article: Article) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsArticle") as? NewsArticleTableViewCell
        else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.backgroundColor = .none
        
        downloadImg(urlString: article.urlToImage, imgView: cell.articleImg)
        
        cell.articleLabel.text = article.title
        cell.websiteLabel.text = (article.source.name ?? K.newsViewHeader).uppercased()
        cell.websiteLabel.textColor = returnSourceColour()
        cell.timeLabel.text = Date().convertStringToDate(dateString: article.publishedAt)
        
        return cell
    }

    func checkRowCount() -> Int {
        if self.isSignedIn && self.userArticlesViewModel.articlesArray.isEmpty {
            return 1
        } else if !self.userArticlesViewModel.articlesArray.isEmpty {
            return self.userArticlesViewModel.articlesArray.count
        } else {
            return 1
        }
    }

    func createProfileSection(indexPathRowSection: Int) -> UITableViewCell {
        return isSignedIn ? createUseFaceIdView() : createNotSignInTableViewCell()
    }
    
    func createNewsArticleSection(indexPathRow: Int) -> UITableViewCell {
        switch self.currentState {
        case .signedInNoFaceId, .signedInWithFaceId:
            let article = self.userArticlesViewModel.articlesArray[indexPathRow]
            
            return createArticleTableViewCell(with: article)
        case .verifyFaceIdFailed, .signingInWithFaceId, .signedOut:
            return createNotSignInTableViewCell()
        }
    }
    
    // TODO: Add footer with a little text about current array count.
}
