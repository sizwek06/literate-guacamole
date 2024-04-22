//
//  OnewsTests.swift
//  OnewsTests
//
//  Created by Sizwe Khathi on 2024/04/20.
//

import Foundation
import XCTest
import OnewsSDK

@testable import Onews

class FirestoreTests: XCTestCase {

    private var fireBaseGeneratorMock: FirestoreMockHelper!
    private var userArticleDelegateMock: UserArticleDelegateMock!
    
    var viewModelUnderTesst: UserArticlesViewModel!
    
    var userUID: String = "pj1QmUVIuvUSnuMz2gv5"
    var articleURL: String = "https://www.wired.com/story/apple-ios-google-chrome-critical-update-march/"
    
    override func setUp() {
        super.setUp()
        
        userArticleDelegateMock = UserArticleDelegateMock()
        fireBaseGeneratorMock = FirestoreMockHelper()
        
        viewModelUnderTesst = UserArticlesViewModel(userArticleDelegate: userArticleDelegateMock,
                                                    onewsFireStore: fireBaseGeneratorMock)
    }
    
    override func tearDown() {
        super.tearDown()
        
        fireBaseGeneratorMock.reset()
        userArticleDelegateMock.reset()
        viewModelUnderTesst = nil
    }
    
    // MARK: Firestore Tests - Get User Articles
    func testGetPopulatedUserSavedArticles() {
        self.fireBaseGeneratorMock.invokeSuccess = true
        
        self.viewModelUnderTesst.queryCurrentUserArticles(using: userUID)
        
        XCTAssertEqual(fireBaseGeneratorMock.articlesArray.count, 3)
        XCTAssertTrue(userArticleDelegateMock.showUserLoadingTriggered)
    }
    
    func testGetEmptyUserSavedArticles() {
        self.fireBaseGeneratorMock.invokeEmpty = true
        
        self.viewModelUnderTesst.queryCurrentUserArticles(using: userUID)
        
        XCTAssertEqual(fireBaseGeneratorMock.articlesArray.count, 0)
        XCTAssertTrue(userArticleDelegateMock.didReceiveArticlesSuccessfullyTriggered)
    }
    
    func testGetUserSavedArticlesError() {
        self.fireBaseGeneratorMock.invokeError = true
        
        self.viewModelUnderTesst.queryCurrentUserArticles(using: userUID)
        
        XCTAssertEqual(self.userArticleDelegateMock.firestoreAPIerror, "Unit Test: Firestore Error")
        XCTAssertTrue(userArticleDelegateMock.didShowErrorTriggered)
    }
    
    // MARK: Firestore Tests - Delete User Articles
    func testDeleteSavedArticles() {
        self.fireBaseGeneratorMock.invokeSuccess = true
        
        self.viewModelUnderTesst.deleteUserArticle(articleURL, uuid: userUID)
        
        XCTAssertTrue(userArticleDelegateMock.hideUserLoadingTriggered)
        XCTAssertTrue(userArticleDelegateMock.didReceiveArticlesSuccessfullyTriggered)
    }
    
    func testDeleteSavedArticlesError() {
        self.fireBaseGeneratorMock.invokeError = true
        
        self.viewModelUnderTesst.deleteUserArticle(articleURL, uuid: userUID)
        
        XCTAssertEqual(self.userArticleDelegateMock.firestoreAPIerror, "Unit Test: Firestore Error")
    }
}
