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
    @Published var isLoading = false
    @Published var isSaving = false
    @Published var errorMessage: String?
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

    public init(
        createUseCase: CreateToDoUseCaseProtocol,
        updateUseCase: UpdateToDoUseCaseProtocol,
        toDo: UIModel.ToDo? = nil
    ) {
        self.createUseCase = createUseCase
        self.updateUseCase = updateUseCase
        self.toDo = toDo
        Logger.userFlow.info("\(Current.logHeader()) inited")
    }

    @MainActor
    func loadData() async {
        guard let toDo else { return }
        title = toDo.title
        description = toDo.description
        createdAt = toDo.createAt
        Logger.userFlow.info("\(Current.logHeader()) Loaded todo with id \(toDo.id):\(toDo.searchable)")
    }

    @MainActor
    func saveData() async {
        guard !isSaving else { return }
        Logger.userFlow.info("\(Current.logHeader()) saving...")
        isSaving = true
        isLoading = true
        errorMessage = nil
        defer {
            isLoading = false
            isSaving = false
        }

        if let toDo {
            Logger.userFlow.info("\(Current.logHeader()) It's an update...")
            do {
                try await updateToDo(id: toDo.id)
            } catch {
                Logger.userFlow.error("\(Current.logHeader()) Updating error: \(error)")
            }
        } else {
            do {
                try await createToDo()
            } catch {
                errorMessage = "Failed to create todo."
                Logger.userFlow.error("\(Current.logHeader()) Creating error: \(error)")
            }
        }
    }

    nonisolated
    func createToDo() async throws {
        try await createUseCase.execute(title: title, description: description)
        Logger.userFlow.info("\(Current.logHeader()) Created toDo with title [\(self.title)]")
    }

    nonisolated
    func updateToDo(id: Int) async throws {
        try await updateUseCase.execute(id: id, title: title, description: description)
        Logger.userFlow.info("\(Current.logHeader()) Updated toDo with id [\(id)]")
    }
}
