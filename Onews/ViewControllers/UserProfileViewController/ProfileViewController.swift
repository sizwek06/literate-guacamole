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
import OnewsSDK

class ProfileViewController: BaseTableViewController {
    
    class func create() -> ProfileViewController {
        let profileViewController = ProfileViewController()
        let onewsFirestore = OnewsFirestore()
        profileViewController.userArticlesViewModel = UserArticlesViewModel(userArticleDelegate: profileViewController,
                                                                            onewsFireStore: onewsFirestore)
        return profileViewController
    }
    
    var isFaceIDVerified: Bool = false
    var isFaceIDEnabled: Bool = false
    
    var userArticlesViewModel: UserArticlesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = K.profileViewTitle
        
        tableView.refreshControl?.addTarget(self, action: #selector(setProfileView), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupTableView()
        self.setUpView()
        verifyUserState()
    }
    
    @objc func setProfileView() {
        
        switch OnewsState.sharedInstance.currentState {
        case .verifyFaceIdFailed, .signingInWithFaceId, .faceIDRequired:
            break
        case .signedInWithFaceId, .signedInNoFaceId, .signedOut:
            if UserDefaults.standard.bool(forKey: K.userDefaultSignedInKey) {
                OnewsState.sharedInstance.currentState = .signedInWithFaceId
                
                self.checkNewsArticlesArray()
            } else {
                OnewsState.sharedInstance.currentState = .signedOut
            }
        }
        
        self.setupTableView()
        tableView.refreshControl?.endRefreshing()
    }
    
    func checkNewsArticlesArray() {
        if let uuid = UserDefaults.standard.string(forKey: K.userDefaultUUIDKey) {
            
            DispatchQueue.main.async {
                self.userArticlesViewModel.queryCurrentUserArticles(using: uuid)
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
    
    func verifyUserState() {
        
        if UserDefaults.standard.bool(forKey: K.userDefaultBiometricsKey) {
            OnewsState.sharedInstance.currentState = .signingInWithFaceId
            
            biometricAuthManager.canEvaluate { (canEvaluate, _, _) in
                guard canEvaluate else {
                    OnewsState.sharedInstance.currentState = .signedInNoFaceId
                    return
                }
                
                biometricAuthManager.evaluate { [weak self] (success, _) in
                    guard let self else { return }
                    guard success else {
                        OnewsState.sharedInstance.currentState = .verifyFaceIdFailed
                        return
                    }
                    OnewsState.sharedInstance.currentState = .signedInWithFaceId
                    self.setProfileView()
                }
            }
        }
        self.setProfileView()
    }
}
