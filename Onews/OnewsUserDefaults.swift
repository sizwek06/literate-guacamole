//
//  OnewsUserDefaults.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/29.
//

import Foundation
import FirebaseAuth

open class OnewsUserDefaults {
    
    public static let sharedInstance = OnewsUserDefaults()
    
    public var user: User?
    public var isSignedIn: Bool?
    // TODO: isBiometricLogIn
    // TODO: isNotificationsOn
    
    public init() {
        loadDefaults()
    }
    
    public func loadDefaults() {
        let userDefaults = UserDefaults.standard
        
        let user = userDefaults.object(forKey: "currentUser") as? User ?? nil
        let isSignedIn = userDefaults.object(forKey: "isSignedIn") as? Bool ?? false
    }
    
    public func saveLoggedInUser(user: User) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(user, forKey: "currentUser")
        userDefaults.set(isSignedIn, forKey: "isSignedIn")
    }
    
    public func clearLoggedInUser() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "currentUser")
        userDefaults.set(false, forKey: "isSignedIn")
    }
}
