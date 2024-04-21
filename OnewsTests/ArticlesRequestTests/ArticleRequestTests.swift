//
//  ArticleRequestTests.swift
//  OnewsSDK
//
//  Created by Sizwe Khathi on 2024/04/20.
//

import Foundation
import XCTest
import OnewsSDK

@testable import Onews

class ArticleRequestTests: XCTestCase {
    
    private var articleDelegateMock: ArticleDelegateMock!
    private var articleGeneratorMock: OnewsMockHelper!
    private var fireBaseGeneratorMock: FirestoreMockHelper!
    
    var viewModelUnderTesst: ArticlesListViewModel!
    
    var searchPhrase: String = "Eclipse"
    var userDefaultRegion: String = "co"
    var userUID: String = "pj1QmUVIuvUSnuMz2gv5"
    var savedArticle: Article!
    
    override func setUp() {
        super.setUp()
        
        articleDelegateMock = ArticleDelegateMock()
        articleGeneratorMock = OnewsMockHelper()
        fireBaseGeneratorMock = FirestoreMockHelper()
        savedArticle = OnewsMockHelper.returnArticleExampleResponse()
        
        viewModelUnderTesst = ArticlesListViewModel(articleDelegate: articleDelegateMock,
                                                    articleRequest: articleGeneratorMock,
                                                    onewsFirestore: fireBaseGeneratorMock)
    }
    
    override func tearDown() {
        super.tearDown()
        
        articleGeneratorMock.reset()
        fireBaseGeneratorMock.reset()
        articleDelegateMock = nil
        viewModelUnderTesst = nil
        articleGeneratorMock = nil
    }
    
    // MARK: Delegate Tests - Get Articles
    func testGetArticlesRequest() {
        self.articleGeneratorMock.invokeSuccess = true
        
        self.viewModelUnderTesst.getArticles()
        
        XCTAssertTrue(self.articleDelegateMock.didReceiveArticlesSuccessfullyTriggered)
        XCTAssertEqual(self.viewModelUnderTesst.articlesArray.count, 32)
        // ArticleResponse.json has total: 34 but 2 have title: Removed, which is filtered
    }
      
    func testEmptyGetArticlesRequest() {
        self.articleGeneratorMock.invokeEmpty = true
        
        self.viewModelUnderTesst.getArticles()
        
        XCTAssertEqual(self.viewModelUnderTesst.articlesArray.count, 0)
        // ArticleResponse.json has total: 34 but 2 have title: Removed, which is filtered
    }
        
    func testGetArticlesRequestNilRegion() {
        self.articleGeneratorMock.invokeSuccess = true
        
        self.viewModelUnderTesst.userDefaultRegion = nil
        self.viewModelUnderTesst.getArticles()
        
        XCTAssertTrue(self.articleDelegateMock.didReceiveArticlesSuccessfullyTriggered)
        XCTAssertEqual(self.viewModelUnderTesst.articlesArray.count, 32)
        // ArticleResponse.json has total: 34 but 2 have title: Removed, which is filtered
    }
    
    func testSearchGetArticlesRequest() {
        self.articleDelegateMock.didShowErrorTriggered = true
        self.articleGeneratorMock.invokeError = true
        
        self.viewModelUnderTesst.getArticles(self.searchPhrase)
        
        XCTAssertTrue(self.articleDelegateMock.didShowErrorTriggered)
        XCTAssertEqual(self.articleDelegateMock.newsAPIerror, "Unit Test: Error")
    }
    
    func testGetArticlesRequestShowLoader() {
        self.articleDelegateMock.showNewsLoadingTriggered = true
        self.viewModelUnderTesst.getArticles(self.searchPhrase)
        XCTAssertTrue(self.articleDelegateMock.showNewsLoadingTriggered)
    }
    
    func testGetArticlesRequestHideLoader() {
        self.articleDelegateMock.hideNewsLoadingTriggered = true
        self.viewModelUnderTesst.getArticles(self.searchPhrase)
        XCTAssertTrue(self.articleDelegateMock.hideNewsLoadingTriggered)
    }
    
    func testGetArticlesRequestError() {
        self.articleDelegateMock.didShowErrorTriggered = true
        self.viewModelUnderTesst.getArticles(self.searchPhrase)
        XCTAssertTrue(self.articleDelegateMock.didShowErrorTriggered)
    }
    
    // MARK: Delegate Tests - SaveNewsArticle
    
    func testSaveNewsArticleResponseShowLoader() {
        self.fireBaseGeneratorMock.invokeSuccess = true
        self.viewModelUnderTesst.saveNewsArticle(using: savedArticle, userUID: userUID)
        XCTAssertTrue(self.articleDelegateMock.showNewsLoadingTriggered)
    }
    
    func testSaveNewsArticleResponseHideLoader() {
        self.fireBaseGeneratorMock.invokeSuccess = true
        self.viewModelUnderTesst.saveNewsArticle(using: savedArticle, userUID: userUID)
        XCTAssertTrue(self.articleDelegateMock.hideNewsLoadingTriggered)
    }
    
    func testSaveNewsArticleResponse() {
        self.fireBaseGeneratorMock.invokeError = true
        self.viewModelUnderTesst.saveNewsArticle(using: savedArticle, userUID: userUID)
        XCTAssertEqual(self.articleDelegateMock.newsAPIerror, "Unit Test: Firestore Error")
    }
}
