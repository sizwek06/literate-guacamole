//
//  UserArticlesDelegate.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/29.
//

import Foundation
import UIKit

protocol UserArticlesDelegate {
    func didReceiveArticlesSuccessfully()
    func didFailWithError(error: String)
    func showUserArticlesLoading()
    func hideNewsLoading()
}
