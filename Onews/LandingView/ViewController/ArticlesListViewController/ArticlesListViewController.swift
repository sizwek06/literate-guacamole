//
//  LandingViewController.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/03/16.
//

import Foundation
import UIKit
import Kingfisher

class ArticlesListViewController: UIViewController {
    
    var articlesListViewModel = ArticlesListViewModel()
    var openArticleURL: ((String) -> Void)?
    var searchText: String = ""
    let search = UISearchController(searchResultsController: nil)
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(MainArticleTableViewCell.self, forCellReuseIdentifier: MainArticleTableViewCell.identifier)
        table.register(UINib(nibName: "NewsArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "newsArticle")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Onews"
        articlesListViewModel.delegate = self
        articlesListViewModel.fetchNewsArticles()
        
        view.addSubview(tableView)
        
        tableView.rowHeight = 150
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        search.delegate = self
        search.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationItem.searchController = search
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
}

extension Date {
    
    func convertStringToDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: dateString) else { return "Date Failed" }

        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self)

        let hours = "\(difference.hour ?? 0)h ago"
        let days = "\(difference.day ?? 0)d ago"
        
        if let daysTimeSince = difference.day, let hoursTimeSince = difference.hour {
            if hoursTimeSince < 24 && daysTimeSince == 0 {
                if let hour = difference.hour, hour       > 0 { return hours }
            } else {
                if let day = difference.day, day          > 0 { return days }
            }
        }
        return ""
    }
}

extension ArticlesListViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchPhrase = searchBar.text else { return }
        
        articlesListViewModel.searchArticleTopic(with: searchPhrase)
        return
    }
}
