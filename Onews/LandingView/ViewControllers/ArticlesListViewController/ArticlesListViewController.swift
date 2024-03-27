//
//  LandingViewController.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/03/16.
//

import Foundation
import UIKit
import Kingfisher

class ArticlesListViewController: BaseTableViewController {
    
    var articlesListViewModel = ArticlesListViewModel()
    
    var searchText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Onews"
        articlesListViewModel.delegate = self
        articlesListViewModel.fetchNewsArticles()
        
        view.addSubview(tableView)
        
        tableView.refreshControl?.addTarget(self, action:
                                                #selector(tableViewReloadNewsArticles),
                                              for: .valueChanged)
        
        search.delegate = self
        search.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationItem.searchController = search
    }
    
    @objc override func tableViewReloadNewsArticles() {
        articlesListViewModel.fetchNewsArticles()
        tableView.refreshControl?.endRefreshing()
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
