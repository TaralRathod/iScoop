//
//  URLRequest+Extension.swift
//  iScoop
//
//  Created by Taral Rathod on 16/02/22.
//

import Foundation

extension URLRequest {
    init(_ resource: Resource) {
        self.init(url: resource.url)
        self.httpMethod = resource.method.rawValue
    }
    
}

extension URL {
    func appending(_ queryItem: String, value: String?) -> Self {

            guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }

            // Create array of existing query items
            var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

            // Create query item
            let queryItem = URLQueryItem(name: queryItem, value: value)

            // Append the new query item in the existing query items array
            queryItems.append(queryItem)

            // Append updated query items array in the url component object
            urlComponents.queryItems = queryItems

            // Returns the url from new url components
            return urlComponents.url!
        }
}
