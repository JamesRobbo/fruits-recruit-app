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
    
    func testInvalidPath() async throws {
        let path = "fakepath"
        do {
            try await self.networkClient.performNetworkCall(model: Fruits.self, path: path)
        } catch NetworkError.invalidRequest {
            XCTAssert(true)
        } catch {
            throw error
        }
    }
    
    func testUsageLoad() async throws {
        try await self.networkClient.recordUsage(event: "load", data: "100")
    }
    
    func testUsageDisplay() async throws {
        try await self.networkClient.recordUsage(event: "display", data: "3000")
    }
    
    func testUsageError() async throws {
        try await self.networkClient.recordUsage(event: "error", data: "test error")
    }
}
