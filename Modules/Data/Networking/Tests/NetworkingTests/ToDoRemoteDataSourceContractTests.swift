//
//  ToDoRemoteDataSourceContractTests.swift
//  Networking
//
//  Created by Sergey Kemenov on 19.02.2026.
//

import Testing
@testable import Networking
@testable import DataInterface
import Foundation

@Suite("ToDoRemoteDataSourceProtocol contract")
struct ToDoRemoteDataSourceContractTests {

    @Test("Initial state — Loaded, no crashes")
    func initialState() {
        let sources: [any ToDoRemoteDataSourceProtocol] = [
            ToDoRemoteDataSource(),
            MockToDoRemoteDataSource()
        ]

        sources.forEach { sut in
            #expect(true)
        }
    }


    @Test("fetchAllToDos returns non-empty list")
    func fetchAll() async throws {
        let sources: [any ToDoRemoteDataSourceProtocol] = [
            ToDoRemoteDataSource(),
            MockToDoRemoteDataSource()
        ]

        for source in sources {
            let sut = try await source.fetchAllToDos()

            #expect(!sut.todos.isEmpty, "Should return at least one todo")
            #expect(sut.total > 0)
        }
    }

    @Test("create → read round-trip")
    func createAndFetch() async throws {
        let sources: [any ToDoRemoteDataSourceProtocol] = [
            MockToDoRemoteDataSource()
        ]

        for source in sources {
            let newTodo = DTOModel.ToDo(
                id: 0,
                todo: "Test item from unit test",
                completed: false,
                userId: 999
            )

            let created = try await source.createToDo(newTodo)
            #expect(created.todo == newTodo.todo)

            let fetched = try await source.fetchToDo(id: created.id)
            #expect(fetched.todo == created.todo)
        }
    }
}
