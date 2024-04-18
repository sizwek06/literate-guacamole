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
    
    class func create() -> ProfileViewController {
        let profileViewController = ProfileViewController()
        profileViewController.userArticlesViewModel = UserArticlesViewModel(userArticleDelegate: profileViewController)
        return profileViewController
    }
    
    var userName: String?
    var isFaceIDVerified: Bool = false
    var isFaceIDEnabled: Bool = false
    
    var userArticlesViewModel: UserArticlesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = K.profileViewTitle
        
        tableView.refreshControl?.addTarget(self, action: #selector(setUpView), for: .valueChanged)
    
        print("ProfileViewController - Current Super State \(String(describing: OnewsState.sharedInstance.currentState))")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        verifyUser()
        setUpView()
        tableView.reloadData()
    }
    
    @objc func setUpView() {
        
        switch OnewsState.sharedInstance.currentState {
        case .signedInWithFaceId, .signedInNoFaceId, .signedOut:
            if UserDefaults.standard.bool(forKey: K.userDefaultSignedInKey) {
                if let user = UserDefaults.standard.string(forKey: K.userDefaultEmailKey) {
                    self.userName = user
                    self.isSignedIn = !user.isEmpty
                    
                    self.checkNewsArticlesArray()
                }
            } else {
                OnewsState.sharedInstance.currentState = .signedOut
            }
        case .verifyFaceIdFailed:
            OnewsState.sharedInstance.currentState = .verifyFaceIdFailed
        case .signingInWithFaceId:
            OnewsState.sharedInstance.currentState = .signingInWithFaceId
        }
        
        self.setupTableView()
    }
    
    func checkNewsArticlesArray() {
        if let uuid = UserDefaults.standard.string(forKey: K.userDefaultUUIDKey) {
            
            DispatchQueue.main.async {
                self.userArticlesViewModel.queryCurrentUserArticles(using: uuid)
                OnewsState.sharedInstance.currentState = .signedInNoFaceId
            }
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
