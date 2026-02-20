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
import Utilities
import CoreData
import LocalStores
import Networking

@Suite("ToDoRepository Contract & Behavior")
struct ToDoRepositoryTests {

    private func makeRepository(
        remote: ToDoRemoteDataSourceProtocol = MockToDoRemoteDataSource(),
        local: ToDoLocalDataSourceProtocol = InMemoryToDoLocalDataSource(),
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

    @Test("createToDo saves locally first, then updates dtoId after remote success")
    func createUpdatesDtoId() async throws {
        let mockLocal = CoreDataToDoLocalDataSource(persistence: PersistenceController.inMemory)
        let repo = makeRepository(local: mockLocal)

        try await mockLocal.clearCache()
        let newToDo = sampleToDo()
        #expect(newToDo.dtoId == nil)

        try await repo.createToDo(newToDo)
        let saved = try await mockLocal.fetchAllToDos()
        #expect(saved.count == 1)
        #expect(!saved.filter { $0.id == newToDo.id}.isEmpty)
    }

    @Test("fetchAllToDos syncs from remote when not synced, sets flag")
    func fetchSyncsWhenNeeded() async throws {
        let mockLocal = InMemoryToDoLocalDataSource()
        let mockDefaults = MockUserDefaultsDataSource(isCoreDataSynced: false)
        let repo = makeRepository(local: mockLocal, userDefaults: mockDefaults)

        #expect(mockDefaults.isCoreDataSynced == false)

        let fetched = try await repo.fetchAllToDos()
        #expect(mockDefaults.isCoreDataSynced == true)
        #expect(try await mockLocal.fetchAllToDos().count == fetched.count)
    }
}

private final class MockUserDefaultsDataSource: UserDefaultsDataSourceProtocol {
    nonisolated(unsafe) var isCoreDataSynced: Bool

    init(isCoreDataSynced: Bool = false) {
        self.isCoreDataSynced = isCoreDataSynced
    }
}
