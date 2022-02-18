//
//  Resource.swift
//  iScoop
//
//  Created by Taral Rathod on 16/02/22.
//

import Foundation

struct Resource {
    let url: URL
    let method: HTTPMethod
}

enum Endpoint: String {
    case baseURL = "https://newsapi.org/v2/"
    case headlinePathURL = "top-headlines?"
    case cnNewsBaseURL = "https://cn-news-info-api.herokuapp.com/"
}

enum QueryParameters: String {
    case country
    case apiKey
    case likes = "likes/"
    case comments = "comments/"
}

enum Countries: String {
    case india = "in"
    case usa = "us"
    case uk = "gb"
}
