//
//  MockAPIResponse.swift
//  iScoopTests
//
//  Created by Taral Rathod on 19/02/22.
//

import Foundation
@testable import iScoop

class MockAPIResponse: NetworkProtocol {

    var didFetchedHeadlines = false
    var jsonFileName = ""

    func executeQuery<T>(_ resource: Resource, result: @escaping ((Result<T>) -> Void)) where T : Decodable, T : Encodable {
        didFetchedHeadlines = true
        guard let data = readLocalFile(forName: jsonFileName) else {return}
        guard let headlines = parse(jsonData: data, model: T.self) else {return}
        result(.success(headlines))
    }
    
    func downloadImage(_ resource: Resource, result: @escaping (Data?, Error?) -> Void) {
        
    }
    
    func cancel() {
        
    }

    func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }

    func parse<T: Codable>(jsonData: Data, model: T.Type) -> T? {
        do {
            let decodedData = try JSONDecoder().decode(T.self,
                                                       from: jsonData)
            return decodedData
        } catch {
            print("decode error")
            return nil
        }
    }
    
}
