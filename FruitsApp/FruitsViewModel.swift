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
        case layoutChange
        case changeMode
    }
    
    enum CollectionSection {
        case fruits
        case button(String, (() -> Void))
    }
    
    enum CollectionLayout {
        case grid
        case list
        case carousel
        
        var next: CollectionLayout {
            switch self {
            case .grid:
                return .list
            case .list:
                return .carousel
            case .carousel:
                return .grid
            }
        }
    }
    
    var fruits = [Fruit]()
    var update: ((FruitsState) -> Void)?
    var layout: CollectionLayout = .grid
    var sections = [CollectionSection]()
    
    private let networkClient = NetworkClient.shared
    
    func setup() {
        // Just adding these three lines so you can see the reload button does its thing
        self.sections = []
        self.fruits = []
        self.update?(.loaded)
        
        Task { [weak self] in
            guard let self else {
                return
            }
            
            do {
                let response = try await self.networkClient.downloadFruits()
                self.fruits = response.fruit
                self.sections = [.fruits,
                                 .button("Change layout", self.changeLayout),
                                 .button("Reload", self.setup),
                                 .button("Change mode", self.changeMode)]
                self.update?(.loaded)
            } catch {
                try? await self.networkClient.recordUsage(event: "error", data: "Fruits download failed")
            }
        }
    }
    
    private func changeLayout() {
        self.layout = self.layout.next
        self.update?(.layoutChange)
    }
    
    private func changeMode() {
        self.update?(.changeMode)
    }
}
