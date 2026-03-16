//
//  ToDoListViewModel.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 07.02.2026.
//

import SwiftUI
import Foundation
import Combine
import DomainInterface
import Logging
import Utilities

public final class ToDoListViewModel: ObservableObject {
    @Published var todos: [UIModel.ToDo] = []
    @Published var searchText = ""

    var filteredTodos: [UIModel.ToDo] {
        searchText.isEmpty
        ? todos
        : todos.filter { $0.searchable.contains(searchText) }
    }
    var todosCount: Int { filteredTodos.count }
    var isTodosEmpty: Bool { todos.isEmpty }
    var isFilteredTodosEmpty: Bool { filteredTodos.isEmpty }

    private let getAllToDosUseCase: GetAllToDosUseCaseProtocol
    private let deleteToDoUseCase: DeleteToDoUseCaseProtocol
    private let completeToDoUseCase: CompleteToDoUseCaseProtocol
    private let errorManager: ErrorManager
    private let networkState: NetworkState

    public init(
        getAllToDosUseCase: GetAllToDosUseCaseProtocol,
        deleteToDoUseCase: DeleteToDoUseCaseProtocol,
        completeToDoUseCase: CompleteToDoUseCaseProtocol,
        errorManager: ErrorManager,
        networkState: NetworkState
    ) {
        self.getAllToDosUseCase = getAllToDosUseCase
        self.deleteToDoUseCase = deleteToDoUseCase
        self.completeToDoUseCase = completeToDoUseCase
        self.errorManager = errorManager
        self.networkState = networkState
    }

    @MainActor
    func loadData() async {
        guard !networkState.isLoading else { return }
        networkState.set(true, for: String.logHeader())
        defer { networkState.set(false, for: String.logHeader()) }

        do {
            todos = try await loadTodos()
        } catch {
            errorManager.show("Failed to load todos.", kind: .init(from: error)) { [weak self] in
                await self?.loadData()
            }
            Logger.userFlow.error("\(String.logHeader()) Loading error: \(error)")
        }
    }

    func exportToDo(_ todo: UIModel.ToDo) -> String {
        let newLine = "\n"
        let complete = String(localized: LocalizedStringResource.todoStatusCompleted)
        let incomplete = String(localized: LocalizedStringResource.todoStatusInProgress)

        let title = String(localized: LocalizedStringResource.todoTitle(todo.title))
        let createAt = String(localized: LocalizedStringResource.todoCreated(todo.createAt))

        let status = String(localized: LocalizedStringResource.todoStatus(todo.isCompleted ? complete : incomplete))
        let description = todo.description.isEmpty
            ? String()
            : newLine + String(localized: LocalizedStringResource.todoDetail(todo.description))

        return title + newLine + status + newLine + createAt + description
    }

    nonisolated
    func loadTodos() async throws -> [UIModel.ToDo] {
        let domainModel = try await getAllToDosUseCase.execute()
        Logger.userFlow.info("\(String.logHeader()) Loaded. [DomainModel.ToDo] has [\(domainModel.count)] records")
        return domainModel.map { UIModel.ToDo(from: $0) }
    }

    @MainActor
    func deleteToDo(id: UUID) async throws {
        guard !networkState.isLoading else { return }
        networkState.set(true, for: String.logHeader())
        defer { networkState.set(false, for: String.logHeader()) }
        do {
            try await deleteToDoUseCase.execute(id: id)
            todos.removeAll { $0.id == id }
            Logger.userFlow.info("\(String.logHeader()) Deleted toDo with id [\(id)]")
        } catch {
            errorManager.show("Failed to delete todo.", kind: .init(from: error))
            Logger.userFlow.error("\(String.logHeader()) Deleting error: \(error)")
        }
    }

    @MainActor
    func completeToDo(_ todo: UIModel.ToDo) async throws {
        guard !networkState.isLoading else { return }
        networkState.set(true, for: String.logHeader())
        defer { networkState.set(false, for: String.logHeader()) }
        do {
            try await completeToDoUseCase.execute(id: todo.id, isCompleted: !todo.isCompleted)
            if let index = todos.firstIndex(of: todo) {
                todos[index].isCompleted.toggle()
            }
            let newStatus = !todo.isCompleted == true ? "Completed" : "In Progress"
            Logger.userFlow.info("\(String.logHeader()) \(newStatus) toDo [\(todo.title)]")
        } catch {
            errorManager.show("Failed to complete todo.", kind: .init(from: error))
            Logger.userFlow.error("\(String.logHeader()) Completing error: \(error)")
        }
    }
}
