//
//  FruitsViewModel.swift
//  FruitsApp
//
//  Created by James Robinson on 15/01/2024.
//

import Foundation

class FruitsViewModel {
    
    enum FruitsState {
        case loaded
        case error(String)
    }
    
    var fruits = [Fruit]()
    var update: ((FruitsState) -> Void)?
    
    private let networkClient = NetworkClient.shared
    
    func setup() {
        Task { [weak self] in
            do {
                let response = try await self?.networkClient.downloadFruits()
                guard let response else {
                    self?.update?(.error("Invalid response"))
                    return
                }
                
                self?.fruits = response.fruit
                self?.update?(.loaded)
            } catch {
                self?.update?(.error("Something went wrong"))
            }
        }
    }
}
