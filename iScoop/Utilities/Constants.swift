//
//  Constants.swift
//  iScoop
//
//  Created by Taral Rathod on 16/02/22.
//

import Foundation

struct Constants {

    // API Key Constant
    static let apiKey = "f66fd701dcd845adbe6aad2bc23c9e90"

    // Storyboard Constants
    static let mainStroyboard = "Main"
    static let newsViewController = "NewsViewController"
    static let newsDetailsViewController = "NewsDetailsViewController"

    // Tableview Cell Constants
    static let heighlightCell = "heighlightNewsCell"
    static let newsCell = "newsCell"
    static let newsDetailsCell = "newsDetailsCell"

    // General Constants
    static let blankString = ""

    // NewsViewController Constants
    static let apiKeyErrorTitle = "API Key not found"
    static let apiKeyErrorMessage = "Please replace given API key in Constants.swift file for property apiKey."
    static let scheme = "://"
    static let backSlash = "/"
    static let hyphen = "-"

    // Asset Constatnts
    static let placeholderImage = "newsPaper"
    static let author = "Author: "

    // CoreData Constants
    static let topHeadlinesEntity = "TopHeadlines"
    static let articlesEntity = "Articles"
    static let sourceEntity = "Source"
}
