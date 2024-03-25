//
//  LandingViewController+Delegate.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/24.
//

import Foundation
import UIKit

extension ArticlesListViewController: ArticleDelegate {

    func reloadNewsArticles() {
        articlesListViewModel.fetchNewsArticles()
        tableView.reloadData()
    }
    
    func didReceiveArticlesSuccessfully() {
        tableView.reloadData()
    }
    
    func didFailWithError(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: { (_) in
            self.reloadNewsArticles()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (_) in
            self.dismiss(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
