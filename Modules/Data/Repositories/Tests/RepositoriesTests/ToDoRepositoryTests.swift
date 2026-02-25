//
//  ToDoRepositoryTests.swift
//  Repositories
//
//  Created by Sergey Kemenov on 19.02.2026.
//

import Testing
@testable import Repositories
import DomainInterface
import DataInterface
import CoreData
import LocalStores
import Networking

@Suite("ToDoRepository Contract & Behavior")
struct ToDoRepositoryTests {

    private func makeRepository(
        remote: ToDoRemoteDataSourceProtocol = MockToDoRemoteDataSource(),
        local: ToDoLocalDataSourceProtocol = CoreDataToDoLocalDataSource(persistence: PersistenceController.inMemory),
        userDefaults: UserDefaultsDataSourceProtocol = MockUserDefaultsDataSource()
    ) -> ToDoRepository {
        ToDoRepository(
            remoteDataSource: remote,
            localDataSource: local,
            userDefaults: userDefaults
        )
    }

    private func sampleToDo() -> DomainModel.ToDo {
        DomainModel.ToDo(
            id: UUID(),
            dtoId: nil,
            todoTitle: "Buy milk & eggs",
            todoDescription: "Important shopping",
            createAt: Date(),
            isCompleted: false,
            userId: 42
        )
    }

    @Test("createToDo saves locally first, even then has no dtoId")
    func createSavedLocally() async throws {
        let mockLocal = CoreDataToDoLocalDataSource(persistence: PersistenceController.inMemory)
        let mockDefaults = MockUserDefaultsDataSource(isCoreDataSynced: true, isAppAlreadyHasFirstLaunch: true)
        try await mockLocal.clearCache()
        let sut = makeRepository(local: mockLocal, userDefaults: mockDefaults)
        let initial = try await mockLocal.fetchAllToDos()

        let newToDo = sampleToDo()
        #expect(newToDo.dtoId == nil)

        try await sut.createToDo(newToDo)
        let saved = try await mockLocal.fetchAllToDos()
        #expect(!saved.filter { $0.id == newToDo.id}.isEmpty)
        #expect(saved.count == initial.count + 1)
    }

    @Test("fetchAllToDos syncs for the first launch should not set isCoreDataSynced flag")
    func fetchSyncsFirstLaunch() async throws {
        let mockLocal = CoreDataToDoLocalDataSource(persistence: PersistenceController.inMemory)
        let mockDefaults = MockUserDefaultsDataSource(isCoreDataSynced: false, isAppAlreadyHasFirstLaunch: false)
        try await mockLocal.clearCache()
        let sut = makeRepository(local: mockLocal, userDefaults: mockDefaults)

        #expect(mockDefaults.isCoreDataSynced == false)
        #expect(mockDefaults.isAppAlreadyHasFirstLaunch == false)

        let fetched = try await sut.fetchAllToDos()
        #expect(mockDefaults.isAppAlreadyHasFirstLaunch == true)
        #expect(mockDefaults.isCoreDataSynced == false)
        #expect(fetched.count == 0)
    }

    @Test("fetchAllToDos syncs from remote when not synced, sets flag")
    func fetchSyncsWhenNeeded() async throws {
        let mockLocal = CoreDataToDoLocalDataSource(persistence: PersistenceController.inMemory)
        let mockDefaults = MockUserDefaultsDataSource(isCoreDataSynced: false, isAppAlreadyHasFirstLaunch: true)
        let sut = makeRepository(local: mockLocal, userDefaults: mockDefaults)

        #expect(mockDefaults.isCoreDataSynced == false)

        let fetched = try await sut.fetchAllToDos()
        #expect(mockDefaults.isCoreDataSynced == true)
        #expect(try await mockLocal.fetchAllToDos().count == fetched.count)
    }
}
