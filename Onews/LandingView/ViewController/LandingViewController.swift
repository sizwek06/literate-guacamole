//
//  LandingViewController.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/03/16.
//

import Foundation
import UIKit
import Kingfisher

class LandingViewController: UIViewController {
    
    var articlesManager = ArticleManager()
    
    internal let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(UINib(nibName: "MainArticleTableVewCell", bundle: nil), forCellReuseIdentifier: "mainArticle")
        table.register(UINib(nibName: "NewsArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "newsArticle")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Onews"
        articlesManager.delegate = self
        articlesManager.fetchNewsArticles()
        
        view.addSubview(tableView)
        
        self.view.addBlurToView()
        tableView.rowHeight = 150
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
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

// MARK: Articles Manager Delegate
extension LandingViewController: ArticleDelegate {
    
    func reloadNewsArticles() {
        articlesManager.fetchNewsArticles()
        tableView.reloadData()
    }
    
    func didReceiveArticlesSuccessfully() {
        tableView.reloadData()
    }
    
    func didFailWithError(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: { (_) in
            self.reloadNewsArticles()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (_) in
            self.dismiss(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
