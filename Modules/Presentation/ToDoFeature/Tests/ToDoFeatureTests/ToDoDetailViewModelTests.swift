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
        updateUseCase: UpdateToDoUseCaseProtocol = MockUpdateToDoUseCase()
    ) -> ToDoDetailViewModel {
        ToDoDetailViewModel(
            createUseCase: createUseCase,
            updateUseCase: updateUseCase
        )
    }

    @Test("Initial state – loading without crashing")
    func initialState() {
        let _ = makeViewModel()
        #expect(true)
    }

    @Test("create mode – save calls create use case")
    func createCallsCreateUseCase() async throws {
        let mockCreate = MockCreateToDoUseCase()
        let sut = makeViewModel(createUseCase: mockCreate)
        
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
            toDo: existing
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
            toDo: UIModel.ToDo(id: existingId, title: "Old", description: "", createAt: "", isCompleted: false)
        )
        await sut.loadData()
        sut.title = "Updated title"
        
        await sut.saveData()

        #expect(mockUpdate.callCount == 1)
        #expect(mockUpdate.lastId == existingId)
        #expect(mockUpdate.lastTitle == "Updated title")
    }
}
