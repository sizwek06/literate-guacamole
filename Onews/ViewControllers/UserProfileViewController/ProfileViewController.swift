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

class ProfileViewController: BaseTableViewController {
    
    var userName: String?
    var currentUser: String?
    
    var userArticlesViewModel = UserArticlesViewModel()
    private let biometricAuthManager = BiometricAuthManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = K.profileViewHeader
        super.tableView.register(UINib(nibName: "UserProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "userProfileTableViewCell")
        super.tableView.register(SingleLabelTableViewCell.self, forCellReuseIdentifier: SingleLabelTableViewCell.identifier)
        
        tableView.refreshControl?.addTarget(self, action: #selector(setUpView), for: .valueChanged)

        verifyUser()
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
    
    @objc override func setUpView() {
        UserDefaults.standard.synchronize()
        
        DispatchQueue.main.async {
            if let user = UserDefaults.standard.string(forKey: K.userDefaultEmailKey),
               let uuid = UserDefaults.standard.string(forKey: K.userDefaultUUIDKey) {
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
    
    func verifyUser() {
        biometricAuthManager.canEvaluate { (canEvaluate, _, canEvaluateError) in
            guard canEvaluate else {
                // Face ID/Touch ID may not be available or configured
                print("Face ID/Touch ID may not be available or configured")
                return
            }
            
            biometricAuthManager.evaluate { [weak self] (success, error) in
                guard let self else { return }
                guard success else {
                    // Face ID/Touch ID may not be configured
                    return
                }
                
                // You are successfully verified
            }
        }
    }
}
