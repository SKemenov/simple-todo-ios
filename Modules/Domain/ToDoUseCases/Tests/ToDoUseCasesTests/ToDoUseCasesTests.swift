//
//  ToDoUseCasesTests.swift
//  ToDoUseCases
//
//  Created by Sergey Kemenov on 19.02.2026.
//

import Testing
@testable import ToDoUseCases
import DomainInterface
import Foundation

@Suite("ToDo UseCases Tests")
struct ToDoUseCasesTests {

    private func makeRepo() -> TestMockToDoRepository { TestMockToDoRepository() }

    private func sampleToDo() -> DomainModel.ToDo {
        .init(
            id: UUID(),
            todoTitle: "Buy milk",
            todoDescription: "Full fat please",
            createAt: Date(),
            isCompleted: false,
            userId: 1
        )
    }

    @Test("Create use case trims title & description + falls back to description if title empty")
    func createValidatesAndSaves() async throws {
        let mockRepo = makeRepo()
        let sut = CreateToDoUseCase(repository: mockRepo)

        try await sut.execute(title: "  Buy eggs  ", description: "Important!")

        let saved = try await mockRepo.fetchAllToDos()
        #expect(saved.count == 1)
        #expect(saved.first?.todoTitle == "Buy eggs")
        #expect(saved.first?.todoDescription == "Important!")

        try await sut.execute(title: "   ", description: "Call mom")

        let saved2 = try await mockRepo.fetchAllToDos()
        #expect(saved2.count == 2)
        #expect(saved2.last?.todoTitle == "Call mom")
        #expect(saved2.last?.todoDescription == "")
    }

    @Test("Create throws when repository fails")
    func createPropagatesError() async throws {
        let mockRepo = makeRepo()
        mockRepo.shouldFailCreate = true

        let sut = CreateToDoUseCase(repository: mockRepo)

        await #expect(throws: (any Error).self) {
            try await sut.execute(title: "Test", description: "")
        }

        #expect(mockRepo.createCallCount == 1)
        #expect(mockRepo.storedTodos.isEmpty)
    }

    @Test("Complete toggles completion state")
    func completeChangesState() async throws {
        let mockRepo = makeRepo()
        let sut = CompleteToDoUseCase(repository: mockRepo)

        let original = sampleToDo()
        try await mockRepo.createToDo(original)

        try await sut.execute(id: original.id, isCompleted: true)

        let updated = try await mockRepo.getToDo(id: original.id)
        #expect(updated?.isCompleted == true)
        #expect(mockRepo.updateCallCount == 1)
    }

    @Test("Complete on non-existing item does nothing")
    func completeNonExistingIsNoop() async throws {
        let mockRepo = makeRepo()
        let sut = CompleteToDoUseCase(repository: mockRepo)

        try await sut.execute(id: UUID(), isCompleted: true)

        #expect(mockRepo.updateCallCount == 0)
    }

    @Test("Delete removes item")
    func deleteRemoves() async throws {
        let mockRepo = makeRepo()
        let sut = DeleteToDoUseCase(repository: mockRepo)

        let item = sampleToDo()
        try await mockRepo.createToDo(item)

        try await sut.execute(id: item.id)

        let all = try await mockRepo.fetchAllToDos()
        #expect(all.isEmpty)
        #expect(mockRepo.deleteCallCount == 1)
    }

    @Test("Update validates and saves new values")
    func updateValidatesAndSaves() async throws {
        let mockRepo = makeRepo()
        let sut = UpdateToDoUseCase(repository: mockRepo)

        let original = sampleToDo()
        try await mockRepo.createToDo(original)

        try await sut.execute(
            id: original.id,
            title: "  Updated title  ",
            description: "New desc"
        )

        let updated = try await mockRepo.getToDo(id: original.id)
        #expect(updated?.todoTitle == "Updated title")
        #expect(updated?.todoDescription == "New desc")
        #expect(mockRepo.updateCallCount == 1)
    }

    @Test("Update with empty title+desc does nothing")
    func updateEmptyIsNoop() async throws {
        let mockRepo = makeRepo()
        let sut = UpdateToDoUseCase(repository: mockRepo)

        let item = sampleToDo()
        try await mockRepo.createToDo(item)

        try await sut.execute(id: item.id, title: "", description: "")

        let after = try await mockRepo.getToDo(id: item.id)
        #expect(after?.todoTitle == item.todoTitle)
        #expect(mockRepo.updateCallCount == 0)
    }

    @Test("Clear cache delegates to repository")
    func clearCacheWorks() async throws {
        let mockRepo = makeRepo()
        let sut = ClearCacheToDoUseCase(repository: mockRepo)

        try await mockRepo.createToDo(sampleToDo())

        try await sut.execute()

        #expect(mockRepo.clearCacheCallCount == 1)
        #expect(try await mockRepo.fetchAllToDos().isEmpty)
    }

    @Test("GetAll fetches from repository")
    func getAllReturnsRepositoryData() async throws {
        let mockRepo = makeRepo()
        let sut = GetAllToDosUseCase(repository: mockRepo)

        let item = sampleToDo()
        try await mockRepo.createToDo(item)

        let result = try await sut.execute()

        #expect(result.count == 1)
        #expect(result.first?.id == item.id)
    }
}
