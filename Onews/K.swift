//
//  K.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/03/25.
//

import Foundation
import UIKit

struct K {
    
    public static let newsArticleURL = "https://newsapi.org/v2/top-headlines?pageSize=50&apiKey=59fd1c88fc3f43d8a4dab7d839612abf&country="
    static let searchURL = "https://newsapi.org/v2/everything?apiKey=59fd1c88fc3f43d8a4dab7d839612abf&sortBy=popularity&q="
    
    static let profileViewHeader = "Profile"
    static let settingsViewHeader = "Settings"
    static let newsViewHeader = "Onews"
    
    static let mainArticleHeader = "TOP NEWS"
    static let otherArticlesHeader = "OTHER ARTICLES"
    
    public static let loadingNewsText = "Loading news, please wait."
    public static let loadingUserText = "Loading, please wait."
    public static let loadingUserSignedInText = "Bing Bong!, You're Logged In!"
    public static let noSessionText = "Not signed in, click below to get started"
    
    static let signInText = "Sign in"
    static let signUpText = "Sign up"
    public static let signOutText = "Sign Out"
    public static let useFaceIDText = "Use FaceID"
    public static let settingsFooterText = "Use the above settings to improve your experience, they will be saved for your next browsing."
    
    static let newsLogo = UIImage(named: "NewsApp")
    static let newsFont = UIFont(name: "SF-Pro", size: 20)
    
    static let alertErrorTitle = "Error"
    static let alertRetry = "Retry"
    static let alertOK = "OK"
    static let alertYes = "Yes"
    static let alertCancel = "Cancel"
    
    static let getMoreArticlesText = "No articles, start reading!"
    
    static let userDefaultEmailKey = "userEmail"
    static let userDefaultUUIDKey = "userUUID"
    static let userDefaultSignedInKey = "userSignedIn"
    static let userDefaultBiometricsKey = "faceID"
    static let userDefaultRegionKey = "region"
    static let userDefaultNotificationsKey = "notification"
    
    public static let regionOptions: KeyValuePairs = ["ar": "Argentina", "au": "Australia", "at": "Austria", "be": "Belgium",
                                       "br": "Brazil", "bg": "Bulgaria", "ca": "Canada", "cn": "China",
                                       "co": "Colombia", "cu": "Cuba", "cz": "Czech Republic", "eg": "Egypt",
                                       "fr": "France", "de": "Germany", "gr": "Greece", "hk": "Hong Kong",
                                       "hu": "Hungary", "in": "India", "id": "Indonesia", "ie": "Ireland",
                                       "il": "Israel", "jp": "Japan", "lv": "Latvia", "lt": "Lithuania",
                                       "my": "Malaysia", "mx": "Mexico", "ma": "Morocco", "nl": "Netherlands",
                                       "nz": "New Zealand", "ng": "Nigeria", "no": "Norway", "ph": "Philippines",
                                       "pl": "Poland", "pt": "Portugal", "ru": "Russia", "sa": "Saudi Arabia",
                                       "rs": "Serbia", "sg": "Singapore", "sk": "Slovakia", "si": "Slovenia",
                                       "za": "South Africa", "kr": "South Korea", "se": "Sweden", "ch": "Switzerland",
                                       "tw": "Taiwan", "th": "Thailand", "tr": "Turkey", "ae": "UAE",
                                       "ua": "Ukraine", "gb": "United Kingdom", "us": "United States", "ve": "Venuzuela"]
    // //A regions endpoint is not available from newsAPI, manually entered these.
    struct fireStoreDb {
        static let articleField = "article"
        static let artileUUIDfield = "uuid"
        static let artileUrlField = "url"
        
        static let fireStoreDbCollection = "newsArticles"
    }
    
    struct newsColor {
        static let oNewsBlack = UIColor.darkGray
        static let oNewsGold = UIColor(red: 0.99, green: 0.80, blue: 0.00, alpha: 1.00)
        static let oNewsGreen = UIColor(red: 0.00, green: 0.55, blue: 0.01, alpha: 1.00)
        static let oNewsMaroon = UIColor(red: 0.72, green: 0.00, blue: 0.00, alpha: 1.00)
        static let oNewsOrange = UIColor(red: 0.86, green: 0.24, blue: 0.00, alpha: 1.00)
        static let oNewsBlue = UIColor(red: 0.25, green: 0.47, blue: 0.77, alpha: 1.00)
    }
}

enum BiometricError: LocalizedError {
    case authenticationFailed
    case userCancel
    case userFallback
    case biometryNotAvailable
    case biometryNotEnrolled
    case biometryLockout
    case unknown

    var errorDescription: String? {
        switch self {
        case .authenticationFailed: return "There was a problem verifying your identity."
        case .userCancel: return "You pressed cancel."
        case .userFallback: return "You pressed password."
        case .biometryNotAvailable: return "Face ID/Touch ID is not available."
        case .biometryNotEnrolled: return "Face ID/Touch ID is not set up."
        case .biometryLockout: return "Face ID/Touch ID is locked."
        case .unknown: return "Face ID/Touch ID may not be configured"
        }
    }
}
