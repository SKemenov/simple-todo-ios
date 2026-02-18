//
//  Protocols.swift
//  DataInterface
//
//  Created by Sergey Kemenov on 09.02.2026.
//

import Foundation
import DomainInterface

public protocol ToDoLocalDataSourceProtocol {
    // For user cases
    func fetchAllToDos() async throws -> [DomainModel.ToDo]
    func saveToDo(_ dto: DomainModel.ToDo) async throws
    func deleteToDo(id: Int) async throws
    // to setup CoreData
    func syncAllTodos(_ dtos: [DomainModel.ToDo]) async throws
    func clearCache() async throws
}
