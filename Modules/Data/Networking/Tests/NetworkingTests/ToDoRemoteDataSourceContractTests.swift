//
//  ToDoRemoteDataSourceContractTests.swift
//  Networking
//
//  Created by Sergey Kemenov on 19.02.2026.
//

import Testing
@testable import Networking
@testable import DataInterface

@Suite("ToDoRemoteDataSourceProtocol contract")
struct ToDoRemoteDataSourceContractTests {

    @Test("Mock conforms to protocol and initializes without crashes")
    func initialState() {
        let sut: any ToDoRemoteDataSourceProtocol = MockToDoRemoteDataSource()
        #expect(sut is MockToDoRemoteDataSource)
    }

    @Test("create → read round-trip")
    func createAndFetch() async throws {
        let source: any ToDoRemoteDataSourceProtocol = MockToDoRemoteDataSource()

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
