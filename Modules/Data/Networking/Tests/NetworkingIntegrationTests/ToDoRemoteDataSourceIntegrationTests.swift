//
//  ToDoRemoteDataSourceIntegrationTests.swift
//  Networking
//
//  Created by Sergey Kemenov on 02.03.2026.
//

import Testing
@testable import Networking
@testable import DataInterface
import Foundation

/// Integration tests that hit the real network (dummyjson.com).
/// NOT included in the default test plan — run manually or via a dedicated CI step.
@Suite("ToDoRemoteDataSource — Integration (network)")
struct ToDoRemoteDataSourceIntegrationTests {

    @Test("Real fetchAllToDos returns non-empty list")
    func fetchAll() async throws {
        let sut = ToDoRemoteDataSource()

        let result = try await sut.fetchAllToDos()

        #expect(!result.todos.isEmpty, "Should return at least one todo")
        #expect(result.total > 0)
        #expect(result.total >= 254)
    }
}
