//
//  Result.swift
//  iScoop
//
//  Created by Taral Rathod on 16/02/22.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
