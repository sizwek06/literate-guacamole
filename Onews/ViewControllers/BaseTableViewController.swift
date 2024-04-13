//
//  BaseTableViewController.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/27.
//

import Foundation
import UIKit
import FirebaseFirestore
import OnewsSDK

class BaseTableViewController: UIViewController {
    
    var openArticleURL: ((String) -> Void)?
    var isSignedIn: Bool = false
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(MainArticleTableViewCell.self, forCellReuseIdentifier: MainArticleTableViewCell.identifier)
        table.refreshControl = UIRefreshControl()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Onews"
        
        view.addSubview(tableView)
        
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    func setupTableView() {
        self.tableView.register(UINib(nibName: "NewsArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "newsArticle")
        self.tableView.register(UINib(nibName: "UserProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "userProfileTableViewCell")
        self.tableView.register(SingleLabelTableViewCell.self, forCellReuseIdentifier: SingleLabelTableViewCell.identifier)
        self.tableView.register(UserFaceIDTableViewCell.self, forCellReuseIdentifier: UserFaceIDTableViewCell.identifier)
        
        self.tableView.frame = self.view.bounds
        self.view.addSubview(self.tableView)
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()
    }
    
    func downloadImg(urlString: String?, imgView: UIImageView) {
        if let urlStr = urlString {
            let url = URL(string: urlStr)
            imgView.kf.indicatorType = .activity
            imgView.kf.setImage(with: url, placeholder: UIImage(named: "launchImg"), options: [.forceRefresh, .transition(.fade(0.2))])
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
    
    func handleOpenArticleURL(url: String, source: String) {
        if !url.isEmpty {
            let articleWebViewController = ArticleWebViewController(url: url, source: source)
            let navController = UINavigationController(rootViewController: articleWebViewController)
            navController.navigationBar.barTintColor = UIColor(named: "CollectionColor")
            self.present(navController, animated: true, completion: nil)
        } else {
            self.bingBong(K.noURLText)
        }
    }
    
    func shareArticleLink(with urlString: String) {
        if !urlString.isEmpty {
            let textToShare = [ urlString ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            self.present(activityViewController, animated: true, completion: nil)
        } else {
            self.bingBong(K.noURLText)
        }
    }
    
    func checkCurrentRegion() {
        if let region = UserDefaults.standard.string(forKey: K.userDefaultRegionKey) {
        } else {
            UserDefaults.standard.setValue("us", forKey: K.userDefaultRegionKey)
        }
    }
    
    func bingBong(_ titleText: String = K.loadingNewsText) {
        OnewsLoaderViewController.sharedInstance.setDisplay(loadingText: titleText)
        OnewsLoaderViewController.sharedInstance.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            OnewsLoaderViewController.sharedInstance.hide()
        }
    }
}

// MARK: Notifications
extension BaseTableViewController {
    
    public func checkNotificationsAuthorizationStatus() {
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.getNotificationSettings { (settings) in
            
            switch settings.authorizationStatus {
            case .denied:
                UserDefaults.standard.setValue(false, forKey: K.userDefaultNotificationsKey)
            default:
                UserDefaults.standard.setValue(true, forKey: K.userDefaultNotificationsKey)
            }
        }
    }
    
    func sendArticleNotification(using article: Article, isSaved: Bool) {
        let content = UNMutableNotificationContent()
        
        content.subtitle = isSaved ? "'\(article.title)' successfully saved!" : "'\(article.title)' successfully deleted!"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
