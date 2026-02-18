//
//  BlogPostRepository.swift
//  DomainInterface
//
//  Created by Sergey Kemenov on 07.02.2026.
//

import Foundation

public protocol ToDoRepositoryProtocol {
    var nextToDoId: Int { get }
    func fetchAllToDos() async throws -> [DomainModel.ToDo]
    func getToDo(id: Int) async throws -> DomainModel.ToDo?
    func createToDo(_ model: DomainModel.ToDo) async throws
    func updateToDo(_ model: DomainModel.ToDo) async throws
    func deleteToDo(id: Int) async throws
    func clearCache() async throws
}
