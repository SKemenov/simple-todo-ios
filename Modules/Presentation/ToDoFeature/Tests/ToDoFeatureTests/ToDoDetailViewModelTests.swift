//
//  ToDoDetailViewModelTests.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 20.02.2026.
//

import Testing
@testable import ToDoFeature
import DomainInterface
import Combine
import Foundation

@Suite("ToDoDetailViewModel")
@MainActor
struct ToDoDetailViewModelTests {

    private func makeViewModel(
        createUseCase: CreateToDoUseCaseProtocol = MockCreateToDoUseCase(),
        updateUseCase: UpdateToDoUseCaseProtocol = MockUpdateToDoUseCase(),
        errorManager: ErrorManager = ErrorManager(),
        networkState: NetworkState = NetworkState()
    ) -> (ToDoDetailViewModel, ErrorManager) {
        let vm = ToDoDetailViewModel(
            createUseCase: createUseCase,
            updateUseCase: updateUseCase,
            errorManager: errorManager,
            networkState: networkState
        )
        return (vm, errorManager)
    }

    @Test("Initial state – loading without crashing")
    func initialState() {
        let (_, _) = makeViewModel()
        #expect(true)
    }

    @Test("create mode – save calls create use case")
    func createCallsCreateUseCase() async throws {
        let mockCreate = MockCreateToDoUseCase()
        let (sut, _) = makeViewModel(createUseCase: mockCreate)

        sut.title = "New task"
        sut.description = "Important"
        await sut.saveData()

        #expect(mockCreate.callCount == 1)
        #expect(mockCreate.lastTitle == "New task")
        #expect(mockCreate.lastDescription == "Important")
    }

    @Test("edit mode – pre-fills fields from model")
    func editModePrefilled() async throws {
        let existing = UIModel.ToDo(
            id: UUID(),
            title: "Edit me",
            description: "Old desc",
            createAt: "",
            isCompleted: false
        )

        let sut = ToDoDetailViewModel(
            createUseCase: MockCreateToDoUseCase(),
            updateUseCase: MockUpdateToDoUseCase(),
            toDo: existing,
            errorManager: ErrorManager(),
            networkState: NetworkState()
        )
        await sut.loadData()

        #expect(sut.title == "Edit me")
        #expect(sut.description == "Old desc")
    }

    @Test("edit mode – save calls update use case")
    func editCallsUpdate() async throws {
        let mockUpdate = MockUpdateToDoUseCase()
        let existingId = UUID()

        let sut = ToDoDetailViewModel(
            createUseCase: MockCreateToDoUseCase(),
            updateUseCase: mockUpdate,
            toDo: UIModel.ToDo(id: existingId, title: "Old", description: "", createAt: "", isCompleted: false),
            errorManager: ErrorManager(),
            networkState: NetworkState()
        )
        await sut.loadData()
        sut.title = "Updated title"

        await sut.saveData()

        #expect(mockUpdate.callCount == 1)
        #expect(mockUpdate.lastId == existingId)
        #expect(mockUpdate.lastTitle == "Updated title")
    }

    @Test("create mode – error pushes to ErrorManager")
    func createErrorPushesToErrorManager() async {
        let mockCreate = MockCreateToDoUseCase()
        mockCreate.shouldThrow = true
        let (sut, errorManager) = makeViewModel(createUseCase: mockCreate)

        sut.title = "Fail"
        sut.description = "This will fail"
        await sut.saveData()

        #expect(!errorManager.errors.isEmpty)
    }

    @Test("edit mode – error pushes to ErrorManager")
    func updateErrorPushesToErrorManager() async {
        let mockUpdate = MockUpdateToDoUseCase()
        mockUpdate.shouldThrow = true
        let errorManager = ErrorManager()
        let sut = ToDoDetailViewModel(
            createUseCase: MockCreateToDoUseCase(),
            updateUseCase: mockUpdate,
            toDo: UIModel.ToDo(id: UUID(), title: "Old", description: "", createAt: "", isCompleted: false),
            errorManager: errorManager,
            networkState: NetworkState()
        )
        await sut.loadData()
        sut.title = "Updated"

        await sut.saveData()

        #expect(!errorManager.errors.isEmpty)
    }
}
