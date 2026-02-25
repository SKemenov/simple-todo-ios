//
//  InMemoryToDoLocalDataSource.swift
//  LocalStores
//
//  Created by Sergey Kemenov on 16.02.2026.
//

#if DEBUG
import Foundation
import DomainInterface
import DataInterface
import Logging

public final class InMemoryToDoLocalDataSource: ToDoLocalDataSourceProtocol {
    private var toDos: [DomainModel.ToDo] = []

    public init() {
        Logger.storage.info("\(String.logHeader()) Started")
    }

    deinit {
        Logger.storage.info("\(String.logHeader()) Deinited")
    }

    public func fetchAllToDos() async throws -> [DomainModel.ToDo] {
        toDos = MockFileLoader.load("todos")
        Logger.storage.info("\(String.logHeader()) fetched [\(self.toDos.count)] records")
        return toDos
    }

    public func saveToDo(_ model: DomainModel.ToDo) async throws {
        if let index = toDos.firstIndex(where: { $0.id == model.id }) {
            toDos[index] = model
        } else {
            toDos.insert(model, at: 0)
        }
    }

    public func getToDo(id: UUID) async throws -> DomainInterface.DomainModel.ToDo? {
        toDos.filter { $0.id == id }.first
    }

    public func deleteToDo(id: UUID) async throws {
        toDos.removeAll { $0.id == id }
        try await syncAllTodos(toDos)
    }

    public func clearCache() async throws {
        toDos = []
    }

    public func syncAllTodos(_ models: [DomainModel.ToDo]) async throws {
        toDos = models
        Logger.storage.info("\(String.logHeader()) synced [\(self.toDos.count)] records")
    }
}
#endif

