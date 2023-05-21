//
//  NewsArticleModel.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/03/25.
//

import Foundation

struct NewsArticleModel {
    
    let articleTitle, articleDescription, articleURL, articleImgURL: String
    let articleAuthor, articleContent, publishedDate: String?
    let articleSource: Source
}
