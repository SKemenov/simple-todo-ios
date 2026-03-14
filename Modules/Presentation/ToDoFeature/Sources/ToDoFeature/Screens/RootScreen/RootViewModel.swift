//
//  RootViewModel.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 18.02.2026.
//

import SwiftUI
import DomainInterface
import Logging
import Utilities

public final class RootViewModel: ObservableObject {
    @Published var totalCount: Int = 0

    private let getAllToDosUseCase: GetAllToDosUseCaseProtocol
    private let clearCacheToDoUseCase: ClearCacheToDoUseCaseProtocol
    private let errorManager: ErrorManager
    private let networkState: NetworkState

    public init(
        getAllToDosUseCase: GetAllToDosUseCaseProtocol,
        clearCacheToDoUseCase: ClearCacheToDoUseCaseProtocol,
        errorManager: ErrorManager,
        networkState: NetworkState
    ) {
        self.getAllToDosUseCase = getAllToDosUseCase
        self.clearCacheToDoUseCase = clearCacheToDoUseCase
        self.errorManager = errorManager
        self.networkState = networkState
    }

    @MainActor
    func loadData() async {
        guard !networkState.isLoading else { return }
        networkState.set(true, for: String.logHeader())
        defer { networkState.set(false, for: String.logHeader()) }

        do {
            let todos = try await getAllToDosUseCase.execute()
            Logger.userFlow.info("\(String.logHeader()) Loaded. Local DataStore has [\(todos.count)] records")
            totalCount = todos.count
        } catch {
            errorManager.show("Failed to load data.", kind: .init(from: error))
            Logger.userFlow.error("\(String.logHeader()) Loading error: \(error)")
        }
    }

    @MainActor
    func clearCache() async {
        guard !networkState.isLoading else { return }
        networkState.set(true, for: String.logHeader())
        defer { networkState.set(false, for: String.logHeader()) }
        do {
            try await clearCacheToDoUseCase.execute()
            Logger.userFlow.info("\(String.logHeader()) Deleted all records")
            totalCount = 0
        } catch {
            errorManager.show("Failed to clear cache.", kind: .init(from: error))
            Logger.userFlow.error("\(String.logHeader()) Clear cache error: \(error)")
        }
    }
}
