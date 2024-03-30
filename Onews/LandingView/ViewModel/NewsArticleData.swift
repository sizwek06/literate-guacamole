//
//  NewsArticleData.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/03/24.
//

import Foundation

// MARK: - NewsArticle
struct NewsArticle: Codable {
    var status: String
    var totalResults: Int
    var articles: [Article]
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
    let uuid: String?
    
    private enum ArticleCodingKeys: CodingKey {
            case source
            case author
            case title
            case description
            case url
            case urlToImage
            case publishedAt
            case content
            case uuid
        }

        init(from decoder: Decoder, uuid: String?) throws {
            let container = try decoder.container(keyedBy: ArticleCodingKeys.self)
            self.source = try container.decode(Source.self, forKey: .source)
            self.author = try? container.decode(String.self, forKey: .author)
            self.title = try container.decode(String.self, forKey: .title)
            self.description = try container.decode(String.self, forKey: .description)
            self.url = try container.decode(String.self, forKey: .url)
            self.urlToImage = try? container.decode(String.self, forKey: .urlToImage)
            self.publishedAt = try container.decode(String.self, forKey: .publishedAt)
            self.content = try? container.decode(String.self, forKey: .publishedAt)
            self.uuid = uuid
        }
}

// MARK: - Source
struct Source: Codable {
    var id: String?
    var name: String
}
