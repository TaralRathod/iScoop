//
//  NetworkManager.swift
//  iScoop
//
//  Created by Taral Rathod on 15/02/22.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

class NetworkManager: NetworkProtocol {
    private var task: URLSessionTask?
    
    func executeQuery<T>(_ resource: Resource,
                         result: @escaping ((Result<T>) -> Void)) where T: Codable {
        let request = URLRequest(resource)
        task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                let actualResult = self.handleNetworkResponse(httpResponse, data: T.self)
                switch actualResult {
                case .success(let modal):
                    guard let `data` = data else {
                        result(.failure(NetworkError.noData))
                        return
                    }
                    do {
                        result(.success(try JSONDecoder().decode(modal.self, from: data)))
                    } catch {
                        result(.failure(NetworkError.serializationError))
                    }
                case .failure(let error):
                    result(.failure(error))
                }
//                switch statusCode {
//                case 200...299:
//                    guard let `data` = data else {
//                        result(.failure(NetworkError.noData))
//                        return
//                    }
//                    do {
//                        result(.success(try JSONDecoder().decode(T.self, from: data)))
//                    } catch let error {
//                        debugPrint(String(data: data, encoding: .utf8) ?? "nothing received")
//                        result(.failure(error))
//                    }
//                case 400...410:
//                    result(.failure(NetworkError.clientError))
//                case 500...510:
//                    result(.failure(NetworkError.serverError))
//                default:
//                    let error = NSError(domain: response.debugDescription, code: statusCode, userInfo: nil)
//                    result(.failure(error))
//                }
            }
        }
        task?.resume()
    }

    func cancel() {
        self.task?.cancel()
    }
}

extension NetworkManager {
    fileprivate func handleNetworkResponse<T>(_ response: HTTPURLResponse, data: T) -> Result<T>{
        switch response.statusCode {
        case 200...299: return .success(data)
        case 401...500: return .failure(NetworkError.clientError)
        case 501...599: return .failure(NetworkError.serverError)
        default: return .failure(NetworkError.failed)
        }
    }
}
