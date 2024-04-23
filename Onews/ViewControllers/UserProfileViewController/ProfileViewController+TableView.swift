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
            switch OnewsState.sharedInstance.currentState {
            case .signingInWithFaceId, .signedOut, .verifyFaceIdFailed, .faceIDRequired:
                return ""
            default:
                return "Articles"
            }
        } else {
            switch OnewsState.sharedInstance.currentState {
            case .signingInWithFaceId, .signedOut, .verifyFaceIdFailed, .faceIDRequired:
                return ""
            default:
                return K.profileHeaderText
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 1 {
            switch OnewsState.sharedInstance.currentState {
            case .signingInWithFaceId, .signedOut, .verifyFaceIdFailed, .faceIDRequired:
                return ""
            default:
                return "You have \(self.userArticlesViewModel.articlesArray.count) news articles, well done! Swipe on the articles to save or share!"
            }
        } else {
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            switch OnewsState.sharedInstance.currentState {
            case .signedInNoFaceId, .signedInWithFaceId:
                if self.userArticlesViewModel.articlesArray.count > 1 {
                    return self.userArticlesViewModel.articlesArray.count
                }
            default:
                return 1
            }
        } else {
            return 1
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            switch OnewsState.sharedInstance.currentState {
                
            case .signingInWithFaceId, .verifyFaceIdFailed, .faceIDRequired:
                return createUseFaceIdView()
            case .signedInNoFaceId, .signedInWithFaceId:
                switch OnewsState.sharedInstance.currentState {
                case .signedInNoFaceId, .signedInWithFaceId:
                    if self.userArticlesViewModel.articlesArray.count > 1 {
                        let article = self.userArticlesViewModel.articlesArray[indexPath.row]
                        
                        return createArticleTableViewCell(with: article)
                    } else {
                        return createNotSignInTableViewCell(true)
                    }
                case .verifyFaceIdFailed, .signingInWithFaceId, .signedOut, .faceIDRequired:
                    return createNotSignInTableViewCell()
                }
            case .signedOut:
                return createNotSignInTableViewCell()
            }
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileTableViewCell") as? UserProfileTableViewCell
            else { return UITableViewCell() }
            
            switch OnewsState.sharedInstance.currentState {
                
            case .signedInWithFaceId, .signedInNoFaceId:
                cell.usernameLabel.text = self.userName ?? K.noSessionText
                cell.setUpProfileView(using: true)
                
            case .verifyFaceIdFailed, .signingInWithFaceId, .faceIDRequired:
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
            switch OnewsState.sharedInstance.currentState {
            case .signedInNoFaceId, .signedInWithFaceId:
                self.bingBong(K.loadingUserSignedInText)
            default:
                self.navigateToSettingsSignIn()
            }
        } else {
            switch OnewsState.sharedInstance.currentState {
                
            case .signedInNoFaceId, .signedInWithFaceId:
                if UserDefaults.standard.bool(forKey: K.userDefaultSignedInKey) && self.userArticlesViewModel.articlesArray.isEmpty {
                    self.navigateToArticles()
                } else if !self.userArticlesViewModel.articlesArray.isEmpty {
                    let article = userArticlesViewModel.articlesArray[indexPath.row]
                    
                    DispatchQueue.main.async {
                        self.handleOpenArticleURL(url: article.url, source: article.source.name ?? "No name")
                    }
                }
            case .verifyFaceIdFailed, .signingInWithFaceId, .faceIDRequired:
                self.verifyUserState()
            case .signedOut:
                self.navigateToSettingsSignIn()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 1 && UserDefaults.standard.bool(forKey: K.userDefaultSignedInKey) {
            let shareAction = UIContextualAction(style: .normal, title: nil) {_, _, completionHandler in
                self.shareArticleLink(with: self.userArticlesViewModel.articlesArray[indexPath.row].url)
                
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
        let currentArticle = self.userArticlesViewModel.articlesArray[indexPath.row]
        
        if indexPath.section == 1 && UserDefaults.standard.bool(forKey: K.userDefaultSignedInKey) {
            let removeAction = UIContextualAction(style: .destructive, title: nil) {_, _, completionHandler in
                
                guard let uuid = UserDefaults.standard.string(forKey: K.userDefaultUUIDKey) else { return }
                
                self.userArticlesViewModel.deleteUserArticle(currentArticle.url,
                                                             uuid: uuid)
                self.userArticlesViewModel.articlesArray.remove(at: indexPath.row)
                
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
    
    func createArticleTableViewCell(with article: Article) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsArticle") as? NewsArticleTableViewCell
        else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.backgroundColor = .none
        
        downloadImg(urlString: article.urlToImage, imgView: cell.articleImg)
        
        cell.articleLabel.text = article.title
        cell.websiteLabel.text = (article.source.name ?? K.newsViewTitle).uppercased()
        cell.websiteLabel.textColor = returnSourceColour()
        cell.timeLabel.text = Date().convertStringToDate(dateString: article.publishedAt)
        
        return cell
    }
    
    func createProfileSection(indexPathRowSection: Int) -> UITableViewCell {
        return UserDefaults.standard.bool(forKey: K.userDefaultSignedInKey) ? createUseFaceIdView() : createNotSignInTableViewCell()
    }
}
