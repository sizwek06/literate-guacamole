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
    var isFaceIDVerified: Bool = false
    var isFaceIDEnabled: Bool = false
    
    var userArticlesViewModel = UserArticlesViewModel()
    private let biometricAuthManager = BiometricAuthManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = K.profileViewHeader
        
        tableView.refreshControl?.addTarget(self, action: #selector(setUpView), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpView()
        if self.isSignedIn { verifyUser() }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.setUpView()
    }
    
    @objc override func setUpView() {
        
        print("ViewWillAppear FaceID", self.isFaceIDVerified)
        UserDefaults.standard.synchronize()
        
        super.tableView.register(UINib(nibName: "UserProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "userProfileTableViewCell")
        super.tableView.register(SingleLabelTableViewCell.self, forCellReuseIdentifier: SingleLabelTableViewCell.identifier)
        super.tableView.register(UserFaceIDTableViewCell.self, forCellReuseIdentifier: UserFaceIDTableViewCell.identifier)
        
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
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
                self.userName = K.noSessionText
                self.isSignedIn = false
            }
            // User email:  Optional("test@gg.com")
            // User details:  Optional("testing")
            
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
        if UserDefaults.standard.bool(forKey: K.userDefaultBiometricsKey) {
            biometricAuthManager.canEvaluate { (canEvaluate, _, _) in
                guard canEvaluate else {
                    // Face ID/Touch ID may not be available or configured
                    print("Face ID/Touch ID may not be available or configured")
                    return
                }
                
                biometricAuthManager.evaluate { (success, _) in
                    guard success else {
                        // Face ID/Touch ID may not be configured
                        return
                    }
                    
                    self.isFaceIDVerified = true
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}
