//
//  ToDoLocalDataSource.swift
//  DataInterface
//
//  Created by Sergey Kemenov on 09.02.2026.
//

import Foundation
import DomainInterface

public protocol ToDoLocalDataSourceProtocol {
    // For user cases
    func fetchAllToDos() async throws -> [DomainModel.ToDo]
    func getToDo(id: UUID) async throws -> DomainModel.ToDo?
    func saveToDo(_ model: DomainModel.ToDo) async throws
    func deleteToDo(id: UUID) async throws
    // to setup CoreData
    func syncAllTodos(_ models: [DomainModel.ToDo]) async throws
    func clearCache() async throws
}
