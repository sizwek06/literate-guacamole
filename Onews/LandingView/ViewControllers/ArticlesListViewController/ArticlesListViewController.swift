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
    
    let search = UISearchController(searchResultsController: nil)
    var searchText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Onews"
        articlesListViewModel.delegate = self
        
        view.addSubview(tableView)
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action:
                                                #selector(tableViewReloadNewsArticles),
                                              for: .valueChanged)
        
        search.delegate = self
        search.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        articlesListViewModel.fetchNewsArticles()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationItem.searchController = search
    }
    
    @objc func tableViewReloadNewsArticles() {
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
