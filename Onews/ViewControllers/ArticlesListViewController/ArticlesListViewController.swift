//
//  LandingViewController.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/03/16.
//

import Foundation
import UIKit
import Kingfisher
import OnewsSDK

class ArticlesListViewController: BaseTableViewController {
    
    class func create() -> ArticlesListViewController {
        let articlesViewController = ArticlesListViewController()
        articlesViewController.articlesListViewModel = ArticlesListViewModel(articleDelegate: articlesViewController)
        return articlesViewController
    }
    
    var articlesListViewModel: ArticlesListViewModel!
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchText: String = ""
    var userUID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = K.newsViewTitle
        
        view.addSubview(tableView)
        tableView.refreshControl?.addTarget(self, action:
                                                #selector(tableViewReloadNewsArticles),
                                              for: .valueChanged)
        searchController.delegate = self
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = true
        
        checkNotificationsAuthorizationStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        articlesListViewModel.getArticles()
        self.setUpView()
        checkCurrentRegion()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationItem.searchController = searchController
    }
    
    @objc func tableViewReloadNewsArticles() {
        articlesListViewModel.getArticles()
        tableView.refreshControl?.endRefreshing()
    }
}

// MARK: Search Bar Delegate
extension ArticlesListViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchPhrase = searchBar.text else { return }
        
        articlesListViewModel.getArticles(searchPhrase)
        return
    }
}
