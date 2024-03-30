//
//  UserViewController.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/26.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestoreSwift

class UserViewController: BaseTableViewController {
    
    var userName: String?
    var currentUser: String?
    var isSignedIn: Bool = false
    
    var userArticlesViewModel = UserArticlesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = K.profileViewHeader
        super.tableView.register(UINib(nibName: "UserProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "userProfileTableViewCell")
        super.tableView.register(SingleLabelTableViewCell.self, forCellReuseIdentifier: SingleLabelTableViewCell.identifier)
        
        tableView.refreshControl?.addTarget(self, action: #selector(setUpView), for: .valueChanged)
        // TODO: Refresh Articles from Firestore

        // if user is not nil
        // Add the email address/name to the profile
        // grab the articles
        // if it is nil, show the sign in button OR 'sign in' to get started
        // tableView.count is then equal to 1 -
        // with click here to view current articles which sends the user to the article screen?
         
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.setUpView()
    }
    
    @objc func setUpView() {
        
        DispatchQueue.main.async {
            if let user = UserDefaults.standard.string(forKey: K.fireStoreDb.userDefaultEmailKey),
               let uuid = UserDefaults.standard.string(forKey: K.fireStoreDb.userDefaultUUIDKey) {
                self.userName = user
                self.isSignedIn = !user.isEmpty
                
                self.userArticlesViewModel.queryUserArticles(using: uuid) { articles in
                    self.userArticlesViewModel.articlesArray = articles
                }
            } else {
                self.userArticlesViewModel.articlesArray.removeAll()
                self.userName = "Not signed in, click below to get started"
                self.isSignedIn = false
            }
            //User email:  Optional("test@gg.com")
            //        User details:  Optional("testing")
            
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func navigateToSettingsSignIn() {
        let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        tabBarController.selectedIndex = 2
        self.dismiss(animated: true, completion: {})
    }
    
    func navigateToArticles() {
        let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        tabBarController.selectedIndex = 1
        self.dismiss(animated: true, completion: {})
    }
}
