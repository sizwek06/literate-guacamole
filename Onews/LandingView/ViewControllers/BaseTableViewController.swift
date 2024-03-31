//
//  BaseTableViewController.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/27.
//

import Foundation
import UIKit
import FirebaseFirestore

class BaseTableViewController: UIViewController {
    
    var openArticleURL: ((String) -> Void)?
    var isSignedIn: Bool = false
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(MainArticleTableViewCell.self, forCellReuseIdentifier: MainArticleTableViewCell.identifier)
        table.refreshControl = UIRefreshControl()
        table.register(UINib(nibName: "NewsArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "newsArticle")
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpView()
    }
    
    func downloadImg(urlString: String?, imgView: UIImageView) {
        if let urlStr = urlString {
            let url = URL(string: urlStr)
            imgView.kf.indicatorType = .activity
            imgView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
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
        let articleWebViewController = ArticleWebViewController(url: url, source: source)
        let navController = UINavigationController(rootViewController: articleWebViewController)
        navController.navigationBar.barTintColor = UIColor(named: "CollectionColor")
        self.present(navController, animated: true, completion: nil)
    }
    
    func shareArticleLink(with urlString: String) {
        let textToShare = [ urlString ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func setUpView() {
        DispatchQueue.main.async {
            if let user = UserDefaults.standard.string(forKey: K.fireStoreDb.userDefaultEmailKey) {
                self.isSignedIn = !user.isEmpty
            }
            print("Article List is user signed in? ", self.isSignedIn)
            
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}
