//
//  MockToDoRemoteDataSourceTests.swift
//  Networking
//
//  Created by Sergey Kemenov on 20.02.2026.
//

import Testing
@testable import Networking
@testable import DataInterface
import Foundation

/// Real dummyjson.com is harder to test, because each endpoints return Ok 200/201 but after that
/// fetchAllToDos() will return an original dummyjson's list.
@Suite("MockToDoRemoteDataSource behavior")
struct MockToDoRemoteDataSourceTests {

    let mock = MockToDoRemoteDataSource()

    @Test("Initial state has 6 items")
    func initialData() async throws {
        let all = try await mock.fetchAllToDos()
        #expect(all.todos.count == 6)
        #expect(all.total == 6)
    }

    @Test("createToDo assigns next ID and adds to beginning")
    func createIncreasesCountAndPrepends() async throws {
        let before = try await mock.fetchAllToDos().todos.count

        _ = try await mock.createToDo(
            DTOModel.ToDo(id: 0, todo: "New task", completed: false, userId: 1)
        )

        let after = try await mock.fetchAllToDos().todos.count
        #expect(after == before + 1)

        let all = try await mock.fetchAllToDos()
        #expect(all.todos.first?.todo == "New task")  // prepended
    }

    @Test("delete removes item and doesn't affect others")
    func delete() async throws {
        let initialCount = try await mock.fetchAllToDos().todos.count

        try await mock.deleteToDo(id: 3)

        let after = try await mock.fetchAllToDos()
        #expect(after.todos.count == initialCount - 1)
        #expect(after.todos.contains { $0.id == 3 } == false)
    }

    @Test("update changes only the target item")
    func update() async throws {
        let original = try await mock.fetchToDo(id: 1)

        var updated = original
        updated.todo = "Updated title"
        updated.completed = true

        let result = try await mock.updateToDo(updated)

        #expect(result.todo == "Updated title")
        #expect(result.completed == true)

        let fetchedAgain = try await mock.fetchToDo(id: 1)
        #expect(fetchedAgain.todo == result.todo)
    }

    @Test("fetchToDo throws notFound when missing")
    func missingItem() async throws {
        await #expect(throws: HTTPClientError.notFound.self) {
            _ = try await mock.fetchToDo(id: 9999)
        }
    }
}
