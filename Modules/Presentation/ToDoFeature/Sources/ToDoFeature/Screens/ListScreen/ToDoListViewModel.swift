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
            Logger.userFlow.error("\(String.logHeader()) Loading error: \(error)")
        }
    }

    func exportToDo(_ todo: UIModel.ToDo) -> String {
        let title = LocalizedStringResource("ToDo: \(todo.title)", bundle: .module)
        let description = LocalizedStringResource("Details: \(todo.description)", bundle: .module)
        let complete = LocalizedStringResource("Completed", bundle: .module)
        let incomplete = LocalizedStringResource("In Progress", bundle: .module)
        let status = LocalizedStringResource("Status: \(todo.isCompleted ? complete : incomplete)", bundle: .module)
        let createAt = LocalizedStringResource("Created at: \(todo.createAt)", bundle: .module)
        let exportText = "\(String(localized: title))\n"
            + "\(String(localized: status))\n"
            + "\(String(localized: createAt))"
            + "\(todo.description.isEmpty ? "" : "\n" + String(localized: description))"
        return exportText
    }

    nonisolated
    func loadTodos() async throws -> [UIModel.ToDo] {
        let domainModel = try await getAllToDosUseCase.execute()
        Logger.userFlow.info("\(String.logHeader()) Loaded. [DomainModel.ToDo] has [\(domainModel.count)] records")
        return domainModel.map { UIModel.ToDo(from: $0) }
    }

    @MainActor
    func deleteToDo(id: UUID) async throws {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            try await deleteToDoUseCase.execute(id: id)
            todos.removeAll { $0.id == id }
            Logger.userFlow.info("\(String.logHeader()) Deleted toDo with id [\(id)]")
        } catch {
            errorMessage = "Failed to delete todo.\n Error: \(error)\n Please try again."
            Logger.userFlow.error("\(String.logHeader()) Deleting error: \(error)")
        }
    }

    @MainActor
    func completeToDo(_ todo: UIModel.ToDo) async throws {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            try await completeToDoUseCase.execute(id: todo.id, isCompleted: !todo.isCompleted)
            if let index = todos.firstIndex(of: todo) {
                todos[index].isCompleted.toggle()
            }
            let newStatus = !todo.isCompleted == true ? "Completed" : "In Progress"
            Logger.userFlow.info("\(String.logHeader()) \(newStatus) toDo [\(todo.title)]")
        } catch {
            errorMessage = "Failed to complete todo.\n Error: \(error)\n Please try again."
            Logger.userFlow.error("\(String.logHeader()) Completing error: \(error)")
        }
    }
}
