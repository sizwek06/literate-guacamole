//
//  K.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/03/25.
//

import Foundation
import UIKit

struct K {
    
    static let newsArticleURL = "https://newsapi.org/v2/top-headlines?country=us&pageSize=35&apiKey=59fd1c88fc3f43d8a4dab7d839612abf"
    static let searchURL = "https://newsapi.org/v2/everything?apiKey=59fd1c88fc3f43d8a4dab7d839612abf&from=2024-03-23&to=2024-03-23&sortBy=popularity&q="
    
    static let mainArticleHeader = "TOP NEWS"
    static let otherArticlesHeader = "OTHER ARTICLES"
    public static let loadingText = "Loading news, please wait."
    static let signInText = "Sign In"
    public static let signOutText = "Sign Out"
    
    static let newsLogo = UIImage(named: "NewsApp")
    static let newsFont = UIFont(name: "SF-Pro", size: 20)
    
    struct newsColor {
        static let oNewsBlack = UIColor.darkGray
        static let oNewsGold = UIColor(red: 0.99, green: 0.80, blue: 0.00, alpha: 1.00)
        static let oNewsGreen = UIColor(red: 0.00, green: 0.55, blue: 0.01, alpha: 1.00)
        static let oNewsMaroon = UIColor(red: 0.72, green: 0.00, blue: 0.00, alpha: 1.00)
        static let oNewsOrange = UIColor(red: 0.86, green: 0.24, blue: 0.00, alpha: 1.00)
        static let oNewsBlue = UIColor(red: 0.25, green: 0.47, blue: 0.77, alpha: 1.00)
    }
}
