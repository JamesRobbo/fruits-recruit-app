//
//  FruitsAppTests.swift
//  FruitsAppTests
//
//  Created by James Robinson on 15/01/2024.
//

import XCTest
@testable import FruitsApp

final class FruitsAppTests: XCTestCase {
    
    private let networkClient = NetworkClient.shared
    
    func testFruitsDownload() async throws {
        do {
            let fruits = try await self.networkClient.downloadFruits()
            XCTAssert(!fruits.fruit.isEmpty)
        } catch {
            throw error
        }
    }
}
