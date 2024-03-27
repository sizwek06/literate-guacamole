//
//  UserAcessDelegate.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/27.
//

import Foundation
import UIKit
import FirebaseAuth

protocol UserAcessDelegate {
    func successfulRegistration(user: User, isRegistration: Bool)
    func didFailWithError(error: String, isRegistration: Bool)
    func showLoader()
    func hideLoader()
}
