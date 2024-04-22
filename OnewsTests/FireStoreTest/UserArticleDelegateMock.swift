//
//  UserArticleDelegateMock.swift
//  OnewsTests
//
//  Created by Sizwe Khathi on 2024/04/21.
//

import Foundation
@testable import Onews

class UserArticleDelegateMock: UserArticlesDelegate {
    
    var showUserLoadingTriggered = false
    var hideUserLoadingTriggered = false
    var didReceiveArticlesSuccessfullyTriggered = false
    var didShowErrorTriggered = false
    var firestoreAPIerror: String?
    
    func didReceiveArticlesSuccessfully() {
        didReceiveArticlesSuccessfullyTriggered = true
    }
    
    func didFailWithError(error: String) {
        didShowErrorTriggered = true
        firestoreAPIerror = error
    }
    
    func showUserArticlesLoading() {
        showUserLoadingTriggered = true
    }
    
    func hideNewsLoading() {
        hideUserLoadingTriggered = true
    }
    
    func reset() {
        showUserLoadingTriggered = false
        hideUserLoadingTriggered = false
        didReceiveArticlesSuccessfullyTriggered = false
        firestoreAPIerror = nil
    }
}
