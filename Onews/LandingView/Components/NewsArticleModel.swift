//
//  NewsArticleModel.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/03/24.
//

import Foundation

// MARK: - ApiRequestOutcome
struct ApiRequestOutcome: Codable {
    let status: String
    let totalResults: Int
    let articles: [NewsArticleModel]
}

// MARK: - NewsArticleModel
struct NewsArticleModel: Codable {
    let source: Source
    let author: String?
    let title, description: String
    let url: String
    let urlToImage: String
    let publishedAt: Date
    let content: String?
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}
