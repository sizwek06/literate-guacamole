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
    
    let search = UISearchController(searchResultsController: nil)
    var searchText: String = ""
    var userUID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = K.newsViewTitle
        
        view.addSubview(tableView)
        tableView.refreshControl?.addTarget(self, action:
                                                #selector(tableViewReloadNewsArticles),
                                              for: .valueChanged)
        search.delegate = self
        search.searchBar.delegate = self
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
        self.navigationItem.searchController = search
    }
    
    @objc func tableViewReloadNewsArticles() {
        articlesListViewModel.getArticles()
        tableView.refreshControl?.endRefreshing()
    }
    
    func setUpView() {
        UserDefaults.standard.synchronize()
        
        DispatchQueue.main.async {
            if UserDefaults.standard.bool(forKey: K.userDefaultSignedInKey) {
                if let user = UserDefaults.standard.string(forKey: K.userDefaultEmailKey),
                   let uuid = UserDefaults.standard.string(forKey: K.userDefaultUUIDKey) {
                    UserDefaults.standard.set(true, forKey: K.userDefaultSignedInKey)
                    self.isSignedIn = !user.isEmpty
                    self.userUID = uuid
                }
            } else {
                UserDefaults.standard.set(false, forKey: K.userDefaultSignedInKey)
                self.isSignedIn = false
            }
            
            self.setupTableView()
            self.tableView.refreshControl?.endRefreshing()
        }
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
