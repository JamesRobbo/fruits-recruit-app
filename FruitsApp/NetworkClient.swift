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
    
    func recordUsage(event: String, data: String) async throws {
        let path = "/fmtvp/recruit-test-data/master/stats"
        let params = [URLQueryItem(name: "event", value: event),
                      URLQueryItem(name: "data", value: data)]
        do {
            let url = try self.buildURL(path: path, params: params)
            _ = try await self.sessionDefault.data(from: url)
        } catch {
            throw error
        }
    }
    
    @discardableResult
    func performNetworkCall<T: Decodable>(model: T.Type,
                                          path: String,
                                          params: [URLQueryItem] = []) async throws -> T {
        do {
            let startTime = DispatchTime.now()
            let url = try self.buildURL(path: path, params: params)
            let (data, _) = try await self.sessionDefault.data(from: url)
            let endTime = DispatchTime.now()
            self.recordLoad(start: startTime, end: endTime)
            let decoded = try JSONDecoder().decode(model.self, from: data)
            return decoded
        } catch {
            throw error
        }
    }
    
    private func buildURL(path: String,
                          params: [URLQueryItem]) throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = self.host
        components.path = path
        components.queryItems = params
        guard let url = components.url else {
            throw NetworkError.invalidRequest
        }
        
        return url
    }
    
    private func recordLoad(start: DispatchTime, end: DispatchTime) {
        Task { [weak self] in
            let elapsedTime = end.uptimeNanoseconds - start.uptimeNanoseconds
            let elapsedTimeInMilliSeconds = Double(elapsedTime) / 1_000_000.0
            try? await self?.recordUsage(event: "load", data: "\(elapsedTimeInMilliSeconds)")
        }
    }
}
