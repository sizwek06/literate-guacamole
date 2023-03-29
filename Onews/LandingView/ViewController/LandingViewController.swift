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
    }
}
