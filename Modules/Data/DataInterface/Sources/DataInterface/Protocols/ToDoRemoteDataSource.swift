//
//  ToDoRemoteDataSource.swift
//  DataInterface
//
//  Created by Sergey Kemenov on 09.02.2026.
//

import Foundation
import DomainInterface

public protocol ToDoRemoteDataSourceProtocol: Sendable {
    func fetchAllToDos() async throws -> DTOModel.ToDos
    func fetchToDos(page: Int) async throws -> DTOModel.ToDos
    func fetchToDo(id: Int) async throws -> DTOModel.ToDo
    func createToDo(_ dto: DTOModel.ToDo) async throws -> DTOModel.ToDo
    func updateToDo(_ dto: DTOModel.ToDo) async throws -> DTOModel.ToDo
    func deleteToDo(id: Int) async throws
}
