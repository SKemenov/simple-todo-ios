//
//  InMemoryToDoLocalDataSource.swift
//  LocalStores
//
//  Created by Sergey Kemenov on 16.02.2026.
//

import Foundation
import DomainInterface
import DataInterface
import Utilities
import Logging

public final class InMemoryToDoLocalDataSource: ToDoLocalDataSourceProtocol {
    private var toDos: [DomainModel.ToDo] = []

    public init() {
        Logger.storage.info("\(Current.logHeader()) Started")
    }

    deinit {
        Logger.storage.info("\(Current.logHeader()) Deinited")
    }

    public func fetchAllToDos() async throws -> [DomainModel.ToDo] {
        toDos = MockFileLoader.load("todos")
        Logger.storage.info("\(Current.logHeader()) fetched [\(self.toDos.count)] records")
        return toDos
    }

    public func saveToDo(_ dto: DomainModel.ToDo) async throws {
        if let index = toDos.firstIndex(where: { $0.id == dto.id }) {
            toDos[index] = dto
        } else {
            toDos.insert(dto, at: 0)
        }
        try await syncAllTodos(toDos)
    }

    public func deleteToDo(id: Int) async throws {
        toDos.removeAll { $0.id == id }
        try await syncAllTodos(toDos)
    }

    public func clearCache() async throws {
        toDos = []
    }

    public func syncAllTodos(_ dtos: [DomainModel.ToDo]) async throws {
        toDos = dtos
        Logger.storage.info("\(Current.logHeader()) synced [\(self.toDos.count)] records")
    }
}
