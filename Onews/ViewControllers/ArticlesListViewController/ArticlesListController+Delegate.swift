//
//  LandingViewController+Delegate.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/24.
//

import Foundation
import UIKit

extension ArticlesListViewController: ArticleDelegate {
    
    func showNewsLoading() {
        OnewsLoaderViewController.sharedInstance.setDisplay(loadingText: K.loadingNewsText)
        OnewsLoaderViewController.sharedInstance.show()
    }
    
    func hideNewsLoading() {
        OnewsLoaderViewController.sharedInstance.hide()
    }

    func reloadNewsArticles() {
        articlesListViewModel.getArticles()
        tableView.reloadData()
    }
    
    func didReceiveArticlesSuccessfully() {
        setupTableView()
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
