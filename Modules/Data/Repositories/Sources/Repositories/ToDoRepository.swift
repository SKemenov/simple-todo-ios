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

public final class ToDoRepository: ToDoRepositoryProtocol {
    private let remoteDataSource: ToDoRemoteDataSourceProtocol
    private let localDataSource: ToDoLocalDataSourceProtocol
    private var userDefaults: UserDefaultsDataSourceProtocol

    public init(
        remoteDataSource: ToDoRemoteDataSourceProtocol,
        localDataSource: ToDoLocalDataSourceProtocol,
        userDefaults: UserDefaultsDataSourceProtocol,
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.userDefaults = userDefaults
        Logger.repos.info("\(String.logHeader()) Repo started")
    }

    public func fetchAllToDos() async throws -> [DomainModel.ToDo] {
        var todos: [DomainModel.ToDo] = try await localDataSource.fetchAllToDos()
        Logger.repos.debug("\(String.logHeader()) CoreData has [\(todos.count)] records")

        switch (userDefaults.isAppAlreadyHasFirstLaunch, userDefaults.isCoreDataSynced) {
        case (false, _):
            Logger.repos.debug("\(String.logHeader()) First launch, should return no records")
            userDefaults.isAppAlreadyHasFirstLaunch = true

        case (true, true):
            Logger.repos.debug("\(String.logHeader()) CoreData Synced, use local data")

        case (true, false):
            Logger.repos.debug("\(String.logHeader()) CoreData not synced, need to fetch DTOs from network")
            let response = try await remoteDataSource.fetchAllToDos()
            let dtos = response.todos
            Logger.repos.debug("\(String.logHeader()) Loaded [\(dtos.count)] records")
            todos = try dtos.map { try ToDoDomainMapper.toDomain($0) }
            try await localDataSource.syncAllTodos(todos)
            todos = try await localDataSource.fetchAllToDos()
            userDefaults.isCoreDataSynced = true
        }
//        try await Task.sleep(for: .seconds(5.0)) // for ProgressView
        Logger.repos.debug("\(String.logHeader()) fetched [\(todos.count)] records")
        return todos
    }

    public func getToDo(id: UUID) async throws -> DomainModel.ToDo? {
        try await localDataSource.getToDo(id: id)
    }

    public func createToDo(_ model: DomainModel.ToDo) async throws {
        try await localDataSource.saveToDo(model)
        let dto = ToDoDomainMapper.toDTO(model)
        let _ = try await remoteDataSource.createToDo(dto)
        Logger.repos.debug("\(String.logHeader()) Created toDo: [\(model)]")
    }

    public func updateToDo(_ model: DomainModel.ToDo) async throws {
        try await localDataSource.saveToDo(model)
        let dto = ToDoDomainMapper.toDTO(model)
        let _ = try await remoteDataSource.updateToDo(dto)
        Logger.repos.debug("\(String.logHeader()) Updated toDo: [\(model)]")
    }

    public func deleteToDo(id: UUID) async throws {
        if let todo = try await localDataSource.getToDo(id: id), let id = todo.dtoId {
            try await remoteDataSource.deleteToDo(id: id)
        }
        try await localDataSource.deleteToDo(id: id)
        Logger.repos.debug("\(String.logHeader()) Deleted toDo [\(id)]")
    }

    public func clearCache() async throws {
        try await localDataSource.clearCache()
        userDefaults.isCoreDataSynced = false
        Logger.repos.debug("\(String.logHeader()) Local DataSource cleared")
    }
}
