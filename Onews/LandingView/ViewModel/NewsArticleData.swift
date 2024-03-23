//
//  NewsArticleData.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/03/24.
//

import Foundation

// MARK: - NewsArticle
struct NewsArticle: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}
