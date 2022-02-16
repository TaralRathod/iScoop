//
//  NetworkProtocol.swift
//  iScoop
//
//  Created by Taral Rathod on 16/02/22.
//

import Foundation

protocol NetworkProtocol: AnyObject {
    func executeQuery<T>(_ resource: Resource,
                         result: @escaping ((Result<T>) -> Void)) where T: Codable
    func cancel()
}
