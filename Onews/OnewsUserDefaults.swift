//
//  OnewsUserDefaults.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/29.
//

import Foundation

open class OnewsUserDefaults {
    
    public static let sharedInstance = OnewsUserDefaults()
    
    public var userEmail: String?
    public var isSignedIn: Bool?
    // TODO: isBiometricLogIn
    // TODO: isNotificationsOn
    
    public init() {
        loadDefaults()
    }
    
    public func loadDefaults() {
        let userDefaults = UserDefaults.standard
        
        self.userEmail = userDefaults.object(forKey: "userEmail") as? String
        self.isSignedIn = userDefaults.object(forKey: "isSignedIn") as? Bool ?? false
    }
    
    public func saveLoggedInUser(email: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(email, forKey: "userEmail")
        userDefaults.synchronize()
    }
    
    public func saveLoggedInUserState(state: Bool) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(isSignedIn, forKey: "isSignedIn")
        userDefaults.synchronize()
    }
    
    public func clearLoggedInUser() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "userEmail")
        userDefaults.set(false, forKey: "isSignedIn")
        userDefaults.synchronize()
    }
}
