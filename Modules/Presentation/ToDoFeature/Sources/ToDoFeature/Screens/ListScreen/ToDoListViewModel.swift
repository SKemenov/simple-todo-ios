//
//  ToDoListViewModel.swift
//  BlogPostFeature
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
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""

    var filteredTodos: [UIModel.ToDo] {
        searchText.isEmpty
        ? todos
        : todos.filter { $0.searchable.contains(searchText) }
    }
    var todosCount: Int { filteredTodos.count }
    var hasTodos: Bool { !todos.isEmpty }
    var hasFilteredTodos: Bool { !filteredTodos.isEmpty }

    private let getAllToDosUseCase: GetAllToDosUseCaseProtocol
    private let deleteToDoUseCase: DeleteToDoUseCaseProtocol
    private let completeToDoUseCase: CompleteToDoUseCaseProtocol

    public init(
        getAllToDosUseCase: GetAllToDosUseCaseProtocol,
        deleteToDoUseCase: DeleteToDoUseCaseProtocol,
        completeToDoUseCase: CompleteToDoUseCaseProtocol
    ) {
        Logger.userFlow.info("\(Current.logHeader()) Inited")
        self.getAllToDosUseCase = getAllToDosUseCase
        self.deleteToDoUseCase = deleteToDoUseCase
        self.completeToDoUseCase = completeToDoUseCase
    }

    @MainActor
    func loadData() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            todos = try await loadTodos()
        } catch {
            errorMessage = "Failed to load todos.\n Loading error: \(error)\n Please try again."
            Logger.userFlow.error("\(Current.logHeader()) Loading error: \(error)")
        }
    }

    func exportToDo(_ todo: UIModel.ToDo) -> String {
        let title: LocalizedStringResource = "ToDo: \(todo.title)"
        let description: LocalizedStringResource = "Details: \(todo.description)"
        let complete: LocalizedStringResource = "Completed"
        let incomplete: LocalizedStringResource = "In Progress"
        let status: LocalizedStringResource = "Status: \(todo.isCompleted ? complete : incomplete)"
        let createAt: LocalizedStringResource = "Created at: \(todo.createAt)"
        let exportText = "\(String(localized: title))\n"
            + "\(String(localized: status))\n"
            + "\(String(localized: createAt))"
            + "\(todo.description.isEmpty ? "" : "\n" + String(localized: description))"
        return exportText
    }

    nonisolated
    func loadTodos() async throws -> [UIModel.ToDo] {
        let domainModel = try await getAllToDosUseCase.execute()
        Logger.userFlow.info("\(Current.logHeader()) Loaded. [DomainModel.ToDo] has [\(domainModel.count)] records")
        return domainModel.map { UIModel.ToDo(from: $0) }
    }

    @MainActor
    func deleteToDo(id: Int) async throws {
        try await deleteToDoUseCase.execute(id: id)
        todos.removeAll { $0.id == id }
        Logger.userFlow.info("\(Current.logHeader()) Deleted toDo with id [\(id)]")
    }

    @MainActor
    func completeToDo(_ todo: UIModel.ToDo) async throws {
        Logger.userFlow.info("\(Current.logHeader()) Try to change completed status for toDo [\(todo.title)]")
        try await completeToDoUseCase.execute(id: todo.id, isCompleted: !todo.isCompleted)
        Logger.userFlow.info("\(Current.logHeader()) Changed status for toDo [\(todo.title)]")
        if let index = todos.firstIndex(of: todo) {
            todos[index].isCompleted.toggle()
        }
        let newStatus = !todo.isCompleted == true ? "Completed" : "In Progress"
        Logger.userFlow.info("\(Current.logHeader()) \(newStatus) toDo [\(todo.title)]")
    }
}
