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

    public init(
        getAllToDosUseCase: GetAllToDosUseCaseProtocol,
        clearCacheToDoUseCase: ClearCacheToDoUseCaseProtocol
    ) {
        self.getAllToDosUseCase = getAllToDosUseCase
        self.clearCacheToDoUseCase = clearCacheToDoUseCase
    }

    @MainActor
    func loadData() async {
        guard let todos = try? await getAllToDosUseCase.execute() else { return }
        Logger.userFlow.info("\(String.logHeader()) Loaded. Local DataStore has [\(todos.count)] records")
        totalCount = todos.count
    }

    @MainActor
    func clearCache() async {
        try? await clearCacheToDoUseCase.execute()
        Logger.userFlow.info("\(String.logHeader()) Deleted all records")
        totalCount = 0
    }
}
