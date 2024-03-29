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
        case "Profile":
            self.selectedIndex = 0
        case "Onews":
            self.selectedIndex = 1
        case "Settings":
            self.selectedIndex = 2
        default:
            break
        }
    }
}
