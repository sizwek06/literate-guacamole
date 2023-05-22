//
//  LandingViewController.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/03/16.
//

import Foundation
import UIKit

class LandingViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 150
        tableView.register(UINib(nibName: "MainArticleTableVewCell", bundle: nil), forCellReuseIdentifier: "mainArticle")
        tableView.register(UINib(nibName: "NewsArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "newsArticle")
    }
    
    func downloadImg(urlString: String, imgView: UIImageView){
        let url = URL(string: urlString)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        imgView.image = UIImage(data: data!)
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
