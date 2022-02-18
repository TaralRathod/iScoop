//
//  NewsDetailsViewModel.swift
//  iScoop
//
//  Created by Taral Rathod on 18/02/22.
//

import Foundation
import CloudKit

protocol NewsDetailsProtocol: AnyObject {
    func likesAndCommentsReceived(article: Articles)
}

class NewsDetailsViewModel: NewsDetailsProtocol {
    weak var delegate: NewsDetailsProtocol?

    init(delegate: NewsDetailsProtocol) {
        self.delegate = delegate
    }

    func fetchLikeAndComments(for article: Articles, network: NetworkProtocol) {
        let dispatchGroup = DispatchGroup()
        var likes = Constants.blankString
        var comments = Constants.blankString

        dispatchGroup.enter()
        fetchLikes(for: article, network: network) { like in
            likes = String(like.likes ?? 0)
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        fetchComments(for: article, network: network) { comment in
            comments = String(comment.comments ?? 0)
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main, work: .init(block: {
            self.storeValueInDatabse(article: article,
                                likes: likes,
                                comments: comments)
        }))
    }

    func fetchLikes(for article: Articles, network: NetworkProtocol, results: @escaping ((Likes) -> Void)) {
        let contentURL = article.url
        guard let url = createURL(from: contentURL, params: .likes) else {return}
        let resource = Resource(url: url, method: .get)
        network.executeQuery(resource) { (result: Result<Likes>) in
            switch result {
            case .success(let likes):
                results(likes)
            case .failure(let error):
                print(error)
            }
        }
    }

    func fetchComments(for article: Articles, network: NetworkProtocol, results: @escaping ((Comments) -> Void)) {
        let contentURL = article.url
        guard let url = createURL(from: contentURL, params: .comments) else {return}
        let resource = Resource(url: url, method: .get)
        network.executeQuery(resource) { (result: Result<Comments>) in
            switch result {
            case .success(let comments):
                results(comments)
            case .failure(let error):
                print(error)
            }
        }
    }

    func createURL(from articleURL: URL?, params: QueryParameters) -> URL? {
        guard let url = articleURL else {return nil}
        let scheme = (url.scheme ?? Constants.blankString) + Constants.scheme
        let urlString = url.absoluteString
        let id = urlString.replacingOccurrences(of: scheme, with: Constants.blankString).replacingOccurrences(of: Constants.backSlash, with: Constants.hyphen)
        let endString = Endpoint.cnNewsBaseURL.rawValue + params.rawValue + id
        guard let endURL = URL(string: endString) else {return nil}
        return endURL
    }

    func storeValueInDatabse(article: Articles, likes: String, comments: String) {
        let predicate = NSPredicate(format: "title = %@", article.title ?? Constants.blankString)
        guard let articles = CoreDataManager.sharedManager.fetchEntity(Articles.self,
                                                                      predicate: predicate)?.first as? Articles else {return}
        articles.likes = likes
        articles.comments = comments

        do {
            try CoreDataManager.sharedManager.persistentContainer.viewContext.save()
            likesAndCommentsReceived(article: articles)
        } catch {
            debugPrint("failed")
        }
        
    }

    func likesAndCommentsReceived(article: Articles) {
        delegate?.likesAndCommentsReceived(article: article)
    }
}
