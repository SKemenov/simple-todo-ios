//
//  TestMockToDoRepository.swift
//  ToDoUseCases
//
//  Created by Sergey Kemenov on 19.02.2026.
//

import Foundation
import DomainInterface

final class TestMockToDoRepository: ToDoRepositoryProtocol {

    private(set) var storedTodos: [DomainModel.ToDo] = []
    private(set) var createCallCount = 0
    private(set) var updateCallCount = 0
    private(set) var deleteCallCount = 0
    private(set) var completeCallCount = 0
    private(set) var clearCacheCallCount = 0

    // You can make these throw / delay / return specific values per test
    var shouldFailCreate = false
    var shouldFailUpdate = false
    var shouldFailDelete = false
    var shouldFailFetch = false

    public func fetchAllToDos() async throws -> [DomainModel.ToDo] {
        if shouldFailFetch {
            throw NSError(domain: "MockError", code: -1)
        }
        return storedTodos
    }

    public func getToDo(id: UUID) async throws -> DomainModel.ToDo? {
        storedTodos.first { $0.id == id }
    }

    public func createToDo(_ model: DomainModel.ToDo) async throws {
        createCallCount += 1
        if shouldFailCreate {
            throw NSError(domain: "MockCreateError", code: -2)
        }
        storedTodos.append(model)
    }

    public func updateToDo(_ model: DomainModel.ToDo) async throws {
        updateCallCount += 1
        if shouldFailUpdate {
            throw NSError(domain: "MockUpdateError", code: -3)
        }

        if let index = storedTodos.firstIndex(where: { $0.id == model.id }) {
            storedTodos[index] = model
        }
    }

    public func deleteToDo(id: UUID) async throws {
        deleteCallCount += 1
        if shouldFailDelete {
            throw NSError(domain: "MockDeleteError", code: -4)
        }
        storedTodos.removeAll { $0.id == id }
    }

    public func clearCache() async throws {
        clearCacheCallCount += 1
        storedTodos.removeAll()
    }
}
