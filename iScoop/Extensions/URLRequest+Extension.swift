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
