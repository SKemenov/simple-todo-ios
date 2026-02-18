//
//  ClearCacheToDoUseCase.swift
//  ToDoUseCases
//
//  Created by Sergey Kemenov on 17.02.2026.
//

import Foundation
import DomainInterface

public final class ClearCacheToDoUseCase: ClearCacheToDoUseCaseProtocol {
    private let repository: ToDoRepositoryProtocol

    public init(repository: ToDoRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async throws {
        try await repository.clearCache()
    }
}
