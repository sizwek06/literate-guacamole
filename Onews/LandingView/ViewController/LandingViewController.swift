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
    func asString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM"
        return dateFormatter.string(from: self)
    }
}
