//
//  NetworkClient.swift
//  FruitsApp
//
//  Created by James Robinson on 15/01/2024.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
}

class NetworkClient {
    
    static let shared = NetworkClient()
    
    private let host = "raw.githubusercontent.com"
    private let sessionDefault: URLSession
    
    // Private init to force the use of shared
    private init() {
        let sessionConfiguration = URLSessionConfiguration.default
        // ignoring caching for this project
        sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        self.sessionDefault = URLSession(configuration: sessionConfiguration)
    }
    
    func downloadFruits() async throws -> Fruits {
        let path = "/fmtvp/recruit-test-data/master/data.json"
        return try await self.performNetworkCall(model: Fruits.self,
                                                 path: path)
    }
    
    func performNetworkCall<T: Decodable>(model: T.Type,
                                          path: String,
                                          params: [URLQueryItem] = []) async throws -> T {
        do {
            var components = URLComponents()
            components.scheme = "https"
            components.host = self.host
            components.path = path
            components.queryItems = params
            guard let url = components.url else {
                throw NetworkError.invalidRequest
            }
            
            let (data, _) = try await self.sessionDefault.data(from: url)
            let decoded = try JSONDecoder().decode(model.self, from: data)
            return decoded
        } catch {
            throw error
        }
    }
}
