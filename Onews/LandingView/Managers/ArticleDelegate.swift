//
//  ArticleDelegate.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/07/01.
//

import Foundation

protocol ArticleDelegate {
    func didReceiveArticlesSuccessfully()
    func didFailWithError(error: Error)
}
