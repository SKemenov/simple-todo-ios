//
//  GetAllToDosUseCase.swift
//  ToDoUseCases
//
//  Created by Sergey Kemenov on 10.02.2026.
//

import Foundation
import DomainInterface

public final class GetAllToDosUseCase: GetAllToDosUseCaseProtocol {
    private let repository: ToDoRepositoryProtocol

    public init(repository: ToDoRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async throws -> [DomainModel.ToDo] {
        try await repository.fetchAllToDos()
    }
}
