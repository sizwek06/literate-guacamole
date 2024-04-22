//
//  ArticleDelegateMock.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/04/20.
//

import Foundation
@testable import Onews

class ArticleDelegateMock: ArticleDelegate {
    
    var showNewsLoadingTriggered = false
    var hideNewsLoadingTriggered = false
    var didReceiveArticlesSuccessfullyTriggered = false
    var didShowErrorTriggered = false
    var newsAPIerror: String?
    
    func didReceiveArticlesSuccessfully() {
        didReceiveArticlesSuccessfullyTriggered = true
    }
    
    func didFailWithError(error: String) {
        didShowErrorTriggered = true
        newsAPIerror = error
    }
    
    func showNewsLoading() {
        showNewsLoadingTriggered = true
    }
    
    func hideNewsLoading() {
        hideNewsLoadingTriggered = true
    }
    
    func reset() {
        showNewsLoadingTriggered = false
        hideNewsLoadingTriggered = false
        didReceiveArticlesSuccessfullyTriggered = false
        newsAPIerror = nil
    }
}
