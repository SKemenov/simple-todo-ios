//
//  ToDoDetailViewModel.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 16.02.2026.
//

import SwiftUI
import Foundation
import Combine
import DomainInterface
import Utilities
import Logging

public final class ToDoDetailViewModel: ObservableObject {
    @Published var toDo: UIModel.ToDo?
//    @Published var isLoading = false
    @Published var isSaving = false
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var createdAt: String = Current.date().createDateStamp()

    var hasChanges: Bool {
        if let toDo {
            title != toDo.title || description != toDo.description
        } else {
            !title.trimSpaces.isEmpty || !description.trimSpaces.isEmpty
        }
    }

    private let createUseCase: CreateToDoUseCaseProtocol
    private let updateUseCase: UpdateToDoUseCaseProtocol
    private let errorManager: ErrorManager
    private let networkState: NetworkState

    public init(
        createUseCase: CreateToDoUseCaseProtocol,
        updateUseCase: UpdateToDoUseCaseProtocol,
        toDo: UIModel.ToDo? = nil,
        errorManager: ErrorManager,
        networkState: NetworkState
    ) {
        self.createUseCase = createUseCase
        self.updateUseCase = updateUseCase
        self.toDo = toDo
        self.errorManager = errorManager
        self.networkState = networkState
    }

    @MainActor
    func loadData() async {
        guard let toDo else { return }
        title = toDo.title
        description = toDo.description
        createdAt = toDo.createAt
        Logger.userFlow.info("\(String.logHeader()) Loaded todo with id \(toDo.id):\(toDo.searchable)")
    }

    @MainActor
    func saveData() async {
        guard !isSaving else { return }
        Logger.userFlow.info("\(String.logHeader()) saving...")
        isSaving = true
        networkState.set(true, for: String.logHeader())
        defer {
            networkState.set(false, for: String.logHeader())
            isSaving = false
        }

        if let toDo {
            Logger.userFlow.info("\(String.logHeader()) It's an update...")
            do {
                try await updateToDo(id: toDo.id)
            } catch {
                errorManager.show("Failed to update todo.", kind: .init(from: error))
                Logger.userFlow.error("\(String.logHeader()) Updating error: \(error)")
            }
        } else {
            do {
                try await createToDo()
            } catch {
                errorManager.show("Failed to create todo.", kind: .init(from: error))
                Logger.userFlow.error("\(String.logHeader()) Creating error: \(error)")
            }
        }
    }

    @MainActor
    func createToDo() async throws {
        try await createUseCase.execute(title: title, description: description)
        Logger.userFlow.info("\(String.logHeader()) Created toDo with title [\(self.title)]")
    }

    @MainActor
    func updateToDo(id: UUID) async throws {
        try await updateUseCase.execute(id: id, title: title, description: description)
        Logger.userFlow.info("\(String.logHeader()) Updated toDo with id [\(id)]")
    }
}
