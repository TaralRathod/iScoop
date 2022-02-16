//
//  TopHeadlines.swift
//  iScoop
//
//  Created by Taral Rathod on 16/02/22.
//

import Foundation

struct TopHeadline {
    var status: String?
    var totalResults: Int?
    var articles: [Article]?
}

struct Article {
    var source: Source?
    var author: String?
    var title: String?
    var description: String?
    var url: URL?
    var urlToImage: URL?
    var publishedAt: String?
    var content: String?
    
}

struct Source {
    var id: String?
    var name: String?
}
