//
//  ToDoRepository.swift
//  Repositories
//
//  Created by Sergey Kemenov on 07.02.2026.
//

import Foundation
import DataInterface
import DomainInterface
import Logging
import Utilities

public final class ToDoRepository: ToDoRepositoryProtocol {
    private let remoteDataSource: ToDoRemoteDataSourceProtocol
    private let localDataSource: ToDoLocalDataSourceProtocol
    private var userDefaults: UserDefaultsDataSourceProtocol
    private var todos: [DomainModel.ToDo] = []

    public var nextToDoId: Int {
        let max = todos.map(\.id).max() ?? todos.count
        return max + 1
    }

    public init(
        remoteDataSource: ToDoRemoteDataSourceProtocol,
        localDataSource: ToDoLocalDataSourceProtocol,
        userDefaults: UserDefaultsDataSourceProtocol,
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.userDefaults = userDefaults
        Logger.repos.info("\(Current.logHeader()) Repo started")
    }

    public func fetchAllToDos() async throws -> [DomainModel.ToDo] {
        if userDefaults.isCoreDataSynced {
            let cachedDTOs = try await localDataSource.fetchAllToDos()
            Logger.repos.debug("\(Current.logHeader()) CoreData has [\(cachedDTOs.count)] records")
            Logger.repos.debug("\(Current.logHeader()) CoreData Synced, use local data")
            todos = cachedDTOs
        } else {
            Logger.repos.debug("\(Current.logHeader()) CoreData not synced, need to fetch DTOs from network")
            let response = try await remoteDataSource.fetchAllToDos()
            let dtos = response.todos
            Logger.repos.debug("\(Current.logHeader()) Loaded [\(dtos.count)] records")
            todos = try dtos.map { try ToDoDomainMapper.toDomain($0) }
            try await localDataSource.syncAllTodos(todos)
            todos = try await localDataSource.fetchAllToDos()
            userDefaults.isCoreDataSynced = true
        }
//        try await Task.sleep(for: .seconds(5.0)) // for ProgressView
        Logger.repos.debug("\(Current.logHeader()) fetched [\(self.todos.count)] records")
        return todos
    }

    public func getToDo(id: Int) async throws -> DomainModel.ToDo? {
        todos.filter( { $0.id == id } ).first
    }

    public func createToDo(_ model: DomainModel.ToDo) async throws {
        try await localDataSource.saveToDo(model)
        todos.append(model)
        let dto = ToDoDomainMapper.toDTO(model)
        let _ = try await remoteDataSource.createToDo(dto)
        Logger.repos.debug("\(Current.logHeader()) Created toDo: [\(model)]")
    }

    public func updateToDo(_ model: DomainModel.ToDo) async throws {
        try await localDataSource.saveToDo(model)
        if model.id < 254 { // dummyjson has only 254 todos
            let dto = ToDoDomainMapper.toDTO(model)
            let _ = try? await remoteDataSource.updateToDo(dto)
        }
        Logger.repos.debug("\(Current.logHeader()) Updated toDo: [\(model)]")
    }

    public func deleteToDo(id: Int) async throws {
        try await remoteDataSource.deleteToDo(id: id)
        try await localDataSource.deleteToDo(id: id)
        Logger.repos.debug("\(Current.logHeader()) Deleted toDo with ID: [\(id)]")
    }

    public func clearCache() async throws {
        try await localDataSource.clearCache()
        userDefaults.isCoreDataSynced = false
        Logger.repos.debug("\(Current.logHeader()) Local DataSource cleared")
    }
}
