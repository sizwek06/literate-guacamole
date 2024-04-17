//
//  TabBarController.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/26.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectedIndex = 1
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch tabBar.selectedItem?.title {
        case K.profileViewTitle:
            self.selectedIndex = 0
        case K.newsViewTitle:
            self.selectedIndex = 1
        case K.settingsViewTitle:
            self.selectedIndex = 2
        default:
            break
        }
    }
    
    func setupTabBar() {
        let articlesListViewController = ArticlesListViewController.create()
        let articlesNavigationController = UINavigationController(rootViewController: articlesListViewController)
        articlesNavigationController.title = K.newsViewTitle
        
        let profileViewController = ProfileViewController.create()
        let userNavigationController = UINavigationController(rootViewController: profileViewController)
        userNavigationController.title = K.profileViewTitle
        
        let settingsNavigationController = UINavigationController(rootViewController: SettingsViewController())
        settingsNavigationController.title = K.settingsViewTitle
        
        articlesNavigationController.tabBarItem.image = UIImage(systemName: "newspaper")
        articlesNavigationController.tabBarItem.selectedImage = UIImage(systemName: "newspaper.fill")
        
        userNavigationController.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        userNavigationController.tabBarItem.selectedImage = UIImage(systemName: "person.crop.circle.fill")
        
        settingsNavigationController.tabBarItem.image = UIImage(systemName: "gearshape")
        settingsNavigationController.tabBarItem.selectedImage = UIImage(systemName: "gearshape.fill")
        
        self.tabBar.tintColor = UIColor(named: "AppearanceColor")
        self.setViewControllers([userNavigationController, articlesNavigationController, settingsNavigationController], animated: true)
    }
}
