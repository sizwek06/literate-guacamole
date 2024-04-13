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
        
        self.userArticlesViewModel.userArticleDelegate = self
        self.verifyUser()
        self.setUpView()
    }
    
    @objc func setUpView() {
        
        switch self.currentState {
        case .signedInWithFaceId, .signedInNoFaceId, .signedOut:
            if UserDefaults.standard.bool(forKey: K.userDefaultSignedInKey) {
                if let user = UserDefaults.standard.string(forKey: K.userDefaultEmailKey),
                   let uuid = UserDefaults.standard.string(forKey: K.userDefaultUUIDKey) {
                    self.userName = user
                    self.isSignedIn = !user.isEmpty
                    
                    DispatchQueue.main.async {
                        self.userArticlesViewModel.queryCurrentUserArticles(using: uuid)
                        self.currentState = .signedInNoFaceId
                    }
                }
            } else {
                self.userArticlesViewModel.articlesArray = []
                self.currentState = .signedOut
            }
        case .verifyFaceIdFailed:
            self.currentState = .verifyFaceIdFailed
        case .signingInWithFaceId:
            self.currentState = .signingInWithFaceId
        }
        
        self.setupTableView()
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
                    }
                }
            }
        }
    }
}
