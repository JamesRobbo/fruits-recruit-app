//
//  Fruits.swift
//  FruitsApp
//
//  Created by James Robinson on 15/01/2024.
//

import Foundation

struct Fruits: Codable {
    let fruit: [Fruit]
}

struct Fruit: Codable {
    // e.g apple
    let type: String
    // seems to be int
    let price: Int
    // in g
    let weight: Int
}
