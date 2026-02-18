//
//  MockToDoRemoteDataSource.swift
//  Networking
//
//  Created by Sergey Kemenov on 17.02.2026.
//

import Foundation
import DataInterface
import Utilities
import Logging

public final class MockToDoRemoteDataSource: ToDoRemoteDataSourceProtocol {
    private var todos: [DTOModel.ToDo] = []

    private var nextToDoId: Int {
        let max = todos.map(\.id).max() ?? todos.count
        return max + 1
    }

    public init() {
        setupMockData()
        Logger.network.info("\(Current.logHeader()) Started. Has \(self.todos.count) records.")
    }

    private func setupMockData() {
        todos = [
            DTOModel.ToDo(id: 1, todo: "Buy groceries", completed: false, userId: 1),
            DTOModel.ToDo(id: 2, todo: "Read a book", completed: false, userId: 1),
            DTOModel.ToDo(id: 3, todo: "Call mom", completed: false, userId: 1),
            DTOModel.ToDo(id: 4, todo: "Go for a walk", completed: true, userId: 1),
            DTOModel.ToDo(id: 5, todo: "Cook dinner", completed: false, userId: 2),
            DTOModel.ToDo(id: 6, todo: "Watch a movie", completed: true, userId: 2),
        ]
    }

    public func fetchAllToDos() async throws -> DTOModel.ToDos {
        DTOModel.ToDos(todos: todos, total: todos.count, skip: 0, limit: 30)
    }

    public func fetchToDos(page: Int) async throws -> DTOModel.ToDos {
        DTOModel.ToDos(todos: todos, total: todos.count, skip: (page - 1) * 30, limit: 30)
    }

    public func fetchToDo(id: Int) async throws -> DTOModel.ToDo {
        if let toDo = todos.first(where: { $0.id == id }) {
            return toDo
        }
        throw HTTPClientError.notFound
    }

    public func createToDo(_ dto: DTOModel.ToDo) async throws -> DTOModel.ToDo {
        var newToDo = dto
        newToDo.id = nextToDoId
        todos.insert(newToDo, at: 0)
        Logger.network.info("\(Current.logHeader()) Created: [\(newToDo)]")
        return newToDo
    }

    public func updateToDo(_ dto: DTOModel.ToDo) async throws -> DTOModel.ToDo {
        guard
            let oldToDo = todos.first(where: { $0.id == dto.id }),
            let position = todos.firstIndex(where: { $0.id == dto.id }) else {
            throw HTTPClientError.notFound
        }
        var newToDo = dto
        newToDo.id = oldToDo.id
        todos[position] = newToDo
        Logger.network.info("\(Current.logHeader()) Updated: [\(newToDo)]")
        return newToDo
    }

    public func deleteToDo(id: Int) async throws {
        todos.removeAll { $0.id == id }
        Logger.network.info("\(Current.logHeader()) Deleted toDo with id: [\(id)]")
    }
}
