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
    //TODO: isBiometricLogIn
    //TODO: isNotificationsOn
    
    public init() {
        loadDefaults()
    }
    
    public func loadDefaults() {
        let userDefaults = UserDefaults.standard
        
        let user = userDefaults.object(forKey: "currentUser") as? User ?? nil
    }
    
    public func saveLoggedInUser(user: User) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(user, forKey: "currentUser")
    }
    
    public func clearLoggedInUser() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "currentUser")
    }
}
