//
//  UserViewController+Delegate.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/30.
//

import Foundation
import UIKit

extension ProfileViewController: UserArticlesDelegate {
    
    func showUserArticlesLoading() {
        OnewsLoaderViewController.sharedInstance.setDisplay(loadingText: K.loadingUsersNewsText)
        OnewsLoaderViewController.sharedInstance.show()
    }
    
    func hideNewsLoading() {
        OnewsLoaderViewController.sharedInstance.hide()
    }

    func reloadNewsArticles() {
        tableView.reloadData()
    }
    
    func didReceiveArticlesSuccessfully() {
        DispatchQueue.main.async {
            self.reloadNewsArticles()
            self.hideNewsLoading()
        }
    }
    
    func didFailWithError(error: String) {
        let alert = UIAlertController(title: K.alertErrorTitle, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: K.alertRetry, style: UIAlertAction.Style.default, handler: { (_) in
            self.reloadNewsArticles()
        }))
        
        alert.addAction(UIAlertAction(title: K.alertCancel, style: UIAlertAction.Style.cancel, handler: { (_) in
            self.dismiss(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
