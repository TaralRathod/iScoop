//
//  NewsViewModel.swift
//  iScoop
//
//  Created by Taral Rathod on 16/02/22.
//

import Foundation

protocol NewsProtocol: AnyObject {
    func headlinesReceived(headlines: TopHeadlines, isConnectionError: Bool)
}

class NewsViewModel: NewsProtocol {
    var delegate: NewsProtocol?

    init(delegate: NewsProtocol) {
        self.delegate = delegate
    }

    func fetchHeadlines(network: NetworkProtocol) {
        let url = URL(string: Endpoint.baseURL.rawValue + Endpoint.headlinePathURL.rawValue)
        guard let urlToCall = url?
                .appending(QueryParameters.country.rawValue, value: Countries.india.rawValue)
                .appending(QueryParameters.apiKey.rawValue, value: Constants.apiKey) else {return}
        
        let resource = Resource(url: urlToCall, method: .get)
        network.executeQuery(resource) { [weak self] (result: Result<TopHeadline>) in
            switch result {
            case .success(let headlines):
                guard let topHeadlines = CoreDataManager.sharedManager.insertTopHeadlines(headlines: headlines) else {return}
                self?.headlinesReceived(headlines: topHeadlines,
                                        isConnectionError: false)
            case .failure(let error):
                if error as! NetworkError == NetworkError.networkNotAvailable {
                    guard let news = CoreDataManager.sharedManager.fetchEntity(TopHeadlines.self) as? [TopHeadlines] else {return}
                    guard let topHeadlines = news.first else {return}
                    self?.headlinesReceived(headlines: topHeadlines,
                                            isConnectionError: true)
                }
            }
        }
    }

    func headlinesReceived(headlines: TopHeadlines, isConnectionError: Bool) {
        delegate?.headlinesReceived(headlines: headlines,
                                    isConnectionError: isConnectionError)
    }
}
