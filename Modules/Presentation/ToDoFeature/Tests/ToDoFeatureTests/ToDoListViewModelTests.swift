//
//  ToDoListViewModelTests.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 20.02.2026.
//

import Testing
@testable import ToDoFeature
import DomainInterface
import Combine
import Foundation

@Suite("ToDoListViewModel")
@MainActor
struct ToDoListViewModelTests {

    private func makeViewModel(
        getAll: GetAllToDosUseCaseProtocol = MockGetAllToDosUseCase(),
        delete: DeleteToDoUseCaseProtocol = MockDeleteToDoUseCase(),
        complete: CompleteToDoUseCaseProtocol = MockCompleteToDoUseCase(),
        errorManager: ErrorManager = ErrorManager(),
        networkState: NetworkState = NetworkState()
    ) -> (ToDoListViewModel, ErrorManager, NetworkState) {
        let vm = ToDoListViewModel(
            getAllToDosUseCase: getAll,
            deleteToDoUseCase: delete,
            completeToDoUseCase: complete,
            errorManager: errorManager,
            networkState: networkState
        )
        return (vm, errorManager, networkState)
    }

    @Test("Initial state – loading = false, todos empty")
    func initialState() {
        let (sut, errorManager, networkState) = makeViewModel()
        #expect(networkState.isLoading == false)
        #expect(sut.todos.isEmpty)
        #expect(errorManager.errors.isEmpty)
    }

    @Test("fetchTodos succeeds – populates list & stops loading")
    func fetchSucceeds() async throws {
        let mockGetAll = MockGetAllToDosUseCase()
        mockGetAll.result = [
            DomainModel.ToDo(id: UUID(), todoTitle: "Buy milk", isCompleted: false),
            DomainModel.ToDo(id: UUID(), todoTitle: "Call mom", isCompleted: true)
        ]

        let (sut, errorManager, networkState) = makeViewModel(getAll: mockGetAll)
        await sut.loadData()

        #expect(networkState.isLoading == false)
        #expect(sut.todos.count == 2)
        #expect(sut.todos[0].title == "Buy milk")
        #expect(errorManager.errors.isEmpty)
    }

    @Test("fetchTodos fails – pushes error to ErrorManager")
    func fetchFailsPushesError() async throws {
        let failingUseCase = MockGetAllToDosUseCase()
        failingUseCase.shouldThrow = true

        let (sut, errorManager, networkState) = makeViewModel(getAll: failingUseCase)
        await sut.loadData()

        #expect(networkState.isLoading == false)
        #expect(sut.todos.isEmpty)
        #expect(!errorManager.errors.isEmpty)
    }

    @Test("toggleComplete calls use case & updates local state optimistically")
    func toggleCompleteOptimisticUpdate() async throws {
        let mockComplete = MockCompleteToDoUseCase()
        let (sut, _, _) = makeViewModel(complete: mockComplete)

        let todoId = UUID()
        let todo = UIModel.ToDo(id: todoId, title: "Task", description: "", createAt: "", isCompleted: false)
        sut.todos = [todo]
        try await sut.completeToDo(todo)

        #expect(mockComplete.callCount == 1)
        #expect(mockComplete.lastId == todoId)
        #expect(mockComplete.lastIsCompleted == true)
        #expect(sut.todos.first?.isCompleted == true)
    }

    @Test("delete removes item from list & calls use case")
    func deleteRemovesItem() async throws {
        let mockDelete = MockDeleteToDoUseCase()
        let (sut, _, _) = makeViewModel(delete: mockDelete)

        let todoId = UUID()
        sut.todos = [
            UIModel.ToDo(id: todoId, title: "Delete me", description: "", createAt: "", isCompleted: false),
            UIModel.ToDo(id: UUID(), title: "Keep me", description: "", createAt: "", isCompleted: false)
        ]
        try await sut.deleteToDo(id: todoId)

        #expect(mockDelete.callCount == 1)
        #expect(mockDelete.lastId == todoId)
        #expect(sut.todos.count == 1)
        #expect(sut.todos.first?.title == "Keep me")
    }
}
