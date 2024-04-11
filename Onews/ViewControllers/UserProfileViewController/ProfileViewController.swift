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
    
    var currentState: OnewsStates = .signedOut {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = K.profileViewHeader
        
        tableView.refreshControl?.addTarget(self, action: #selector(setUpView), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isSignedIn { verifyUser() }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.setUpView()
    }
    
    @objc override func setUpView() {
        super.tableView.register(UINib(nibName: "UserProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "userProfileTableViewCell")
        super.tableView.register(SingleLabelTableViewCell.self, forCellReuseIdentifier: SingleLabelTableViewCell.identifier)
        super.tableView.register(UserFaceIDTableViewCell.self, forCellReuseIdentifier: UserFaceIDTableViewCell.identifier)
        
        switch self.currentState {
        case .signedInWithFaceId, .signedInNoFaceId, .signedOut:
            if UserDefaults.standard.bool(forKey: K.userDefaultSignedInKey) {
                if let user = UserDefaults.standard.string(forKey: K.userDefaultEmailKey),
                   let uuid = UserDefaults.standard.string(forKey: K.userDefaultUUIDKey) {
                    self.userName = user
                    self.isSignedIn = !user.isEmpty
                    
                    self.userArticlesViewModel.queryUserArticles(using: uuid) { articles in
                        self.userArticlesViewModel.articlesArray = articles
                    }
                    self.currentState = .signedInNoFaceId
                }
                
                self.tableView.frame = self.view.bounds
                self.view.addSubview(self.tableView)
            }
        case .verifyFaceIdFailed:
            self.currentState = .verifyFaceIdFailed
        case .signingInWithFaceId:
            self.currentState = .signingInWithFaceId
        }
        
        DispatchQueue.main.async {
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
            self.currentState = .signingInWithFaceId
            
            biometricAuthManager.canEvaluate { (canEvaluate, _, _) in
                guard canEvaluate else {
                    self.currentState = .signedInNoFaceId
                    return
                }
                
                biometricAuthManager.evaluate { [weak self] (success, _) in
                    guard let self else { return }
                    guard success else {
                        self.currentState = .verifyFaceIdFailed
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.currentState = .signedInWithFaceId
                        self.setUpView()
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.currentState = .signedInNoFaceId
                self.setUpView()
            }
        }
    }
    
    func bingBong() {
        OnewsLoaderViewController.sharedInstance.setDisplay(loadingText: K.loadingUserSignedInText)
        OnewsLoaderViewController.sharedInstance.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            self.hideNewsLoading()
        }
    }
}
