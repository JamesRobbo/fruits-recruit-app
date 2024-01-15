//
//  NetworkClient.swift
//  FruitsApp
//
//  Created by James Robinson on 15/01/2024.
//

import Foundation

class NetworkClient {
    
    static let shared = NetworkClient()
    
    private let sessionDefault: URLSession
    
    // Private init to force the use of shared
    private init() {
        let sessionConfiguration = URLSessionConfiguration.default
        // ignoring caching for this project
        sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        self.sessionDefault = URLSession(configuration: sessionConfiguration)
    }
}
