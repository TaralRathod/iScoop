//
//  NetworkErrors.swift
//  iScoop
//
//  Created by Taral Rathod on 16/02/22.
//

import Foundation

enum NetworkError: Error {
    case noData
    case serializationError
    case clientError
    case serverError
    case networkNotAvailable
    case failed
}
