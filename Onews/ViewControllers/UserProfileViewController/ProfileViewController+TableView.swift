//
//  UserViewController+TableView.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/26.
//

import Foundation
import UIKit

extension ProfileViewController {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         return section == 0 ? "" : (self.isSignedIn && self.isFaceIDVerified ? "Articles" : "")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if UserDefaults.standard.bool(forKey: K.userDefaultBiometricsKey) {
                
                if self.isFaceIDVerified {
                    if self.isSignedIn && self.userArticlesViewModel.articlesArray.isEmpty {
                        return 1
                    } else if !self.userArticlesViewModel.articlesArray.isEmpty {
                        return self.userArticlesViewModel.articlesArray.count
                    } else {
                        return 1
                    }
                } else {
                    return 1
                }
            } else {
                if self.isSignedIn && self.userArticlesViewModel.articlesArray.isEmpty {
                    return 1
                } else if !self.userArticlesViewModel.articlesArray.isEmpty {
                    return self.userArticlesViewModel.articlesArray.count
                } else {
                    return 1
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 180 : UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Array count is: \(self.userArticlesViewModel.articlesArray.count)")
        print("Array: \(self.userArticlesViewModel.articlesArray)")
        
        if UserDefaults.standard.bool(forKey: K.userDefaultBiometricsKey) {
            // The below is if the user has failed the faceID
            if self.isFaceIDVerified {
                if indexPath.section == 1 {
                    return isSignedIn ? createUseFaceIdView() : createNoSignInTableViewCell()
                } else {
                    return createProfileView()
                }
            } else {
                // The below is if the user has passed the faceID
                if indexPath.section == 1 {
                    if self.isSignedIn && self.userArticlesViewModel.articlesArray.isEmpty {
                        return createNoSignInTableViewCell()
                    } else if self.isSignedIn {
                        let article = self.userArticlesViewModel.articlesArray[indexPath.row]
                        
                        return createArticleTableViewCell(with: article)
                    } else {
                        return createNoSignInTableViewCell()
                    }
                }
            }
        } else {
            if self.isSignedIn && self.userArticlesViewModel.articlesArray.isEmpty {
                return createNoSignInTableViewCell()
            } else if self.isSignedIn {
                let article = self.userArticlesViewModel.articlesArray[indexPath.row]
                
                return createArticleTableViewCell(with: article)
            } else {
                return createNoSignInTableViewCell()
            }
        }
        return createProfileView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if self.isSignedIn && self.isFaceIDVerified {
                OnewsLoaderViewController.sharedInstance.setDisplay(loadingText: K.loadingUserSignedInText)
                OnewsLoaderViewController.sharedInstance.show()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    guard let self else { return }
                    self.hideNewsLoading()
                }
            } else {
                self.navigateToSettingsSignIn()
            }
        } else {
            if UserDefaults.standard.bool(forKey: K.userDefaultBiometricsKey) {
                if self.isSignedIn && self.isFaceIDVerified {
                    if self.isSignedIn && self.userArticlesViewModel.articlesArray.isEmpty {
                        self.navigateToArticles()
                    } else if !self.userArticlesViewModel.articlesArray.isEmpty {
                        let article = userArticlesViewModel.articlesArray[indexPath.row]
                        
                        DispatchQueue.main.async {
                            self.handleOpenArticleURL(url: article.url, source: article.source.name)
                        }
                    } else if !self.isSignedIn {
                        self.navigateToSettingsSignIn()
                    } else {
                        self.verifyUser()
                    }
                }
            } else {
                if self.isSignedIn && self.userArticlesViewModel.articlesArray.isEmpty {
                    self.navigateToArticles()
                } else if !self.userArticlesViewModel.articlesArray.isEmpty {
                    let article = userArticlesViewModel.articlesArray[indexPath.row]
                    
                    DispatchQueue.main.async {
                        self.handleOpenArticleURL(url: article.url, source: article.source.name)
                    }
                } else if !self.isSignedIn {
                    self.navigateToSettingsSignIn()
                } else {
                    self.verifyUser()
                }
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
        
        if indexPath.section == 1 && isSignedIn {
            let removeAction = UIContextualAction(style: .destructive, title: nil) {_, _, completionHandler in
                
                guard let uuid = UserDefaults.standard.string(forKey: K.userDefaultUUIDKey) else { return }
                
                self.userArticlesViewModel.deleteUserArticles(using: self.userArticlesViewModel.articlesArray[indexPath.row].url,
                                                              uuid: uuid)
                
                completionHandler(true)
            }
            removeAction.backgroundColor = .systemRed
            
            let swipeConfiguration = UISwipeActionsConfiguration(actions: [removeAction])
            swipeConfiguration.performsFirstActionWithFullSwipe = true
            
            removeAction.image = addLabelToImage(imageString: "trash.fill", labelString: "Delete")
            
            self.setUpView()
            
            return swipeConfiguration
        } else {
            let swipeConfiguration = UISwipeActionsConfiguration()
            return swipeConfiguration
        }
    }
    
    func createNoSignInTableViewCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SingleLabelTableViewCell.identifier) as? SingleLabelTableViewCell
        else { return UITableViewCell() }

        cell.signOutLabel.text = self.isSignedIn ? K.getMoreArticlesText: K.signInText
        cell.signOutLabel.textColor = self.isSignedIn ? .black : .systemBlue
        cell.userState = self.isSignedIn
        
        return cell
    }
    
    func createProfileView() -> UITableViewCell {
        print("CellForRow FaceID", self.isFaceIDVerified)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileTableViewCell") as? UserProfileTableViewCell,
              let user = self.userName
        else { return UITableViewCell() }
        
        print("CellForRow userName", user)
        cell.usernameLabel.text = user
        
        cell.isFaceIDVerified = self.isFaceIDVerified
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
        cell.websiteLabel.text = article.source.name.uppercased()
        cell.websiteLabel.textColor = returnSourceColour()
        cell.timeLabel.text = Date().convertStringToDate(dateString: article.publishedAt)
        
        return cell
    }
    
    // TODO: Add footer with a little text about current array count.
}
