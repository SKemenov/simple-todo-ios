//
//  UIMockToDoRepository.swift
//  ToDoUseCases
//
//  Created by Sergey Kemenov on 19.02.2026.
//

#if DEBUG
import Foundation
import DomainInterface

final class UIMockToDoRepository: ToDoRepositoryProtocol {

    private(set) var storedTodos: [DomainModel.ToDo] = []
    var isLocalStoreSynced = false

    public func fetchAllToDos() async throws -> [DomainModel.ToDo] {
        if !isLocalStoreSynced {
            storedTodos = mockModels
            isLocalStoreSynced = true
        }
        return storedTodos
    }

    public func getToDo(id: UUID) async throws -> DomainModel.ToDo? {
        storedTodos.first { $0.id == id }
    }

    public func createToDo(_ model: DomainModel.ToDo) async throws {
        storedTodos.append(model)
    }

    public func updateToDo(_ model: DomainModel.ToDo) async throws {
        if let index = storedTodos.firstIndex(where: { $0.id == model.id }) {
            storedTodos[index] = model
        }
    }

    public func deleteToDo(id: UUID) async throws {
        storedTodos.removeAll { $0.id == id }
    }

    public func clearCache() async throws {
        storedTodos.removeAll()
    }

    private let mockModels = [
        DomainModel.ToDo(todoTitle: "Do something nice for someone you care about"),
        DomainModel.ToDo(todoTitle: "Memorize a poem", isCompleted: true),
        DomainModel.ToDo(todoTitle: "Watch a classic movie"),
        DomainModel.ToDo(todoTitle: "Watch a documentary", isCompleted: true),
        DomainModel.ToDo(todoTitle: "Invest in cryptocurrency", isCompleted: true),
        DomainModel.ToDo(todoTitle: "Contribute code or a monetary donation to an open-source software project"),
        DomainModel.ToDo(todoTitle: "Solve a Rubik's cube", isCompleted: true),
        DomainModel.ToDo(todoTitle: "Bake pastries for yourself and neighbor"),
    ]
}
#endif
