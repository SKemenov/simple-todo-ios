//
//  DeleteToDoUseCase.swift
//  ToDoUseCases
//
//  Created by Sergey Kemenov on 10.02.2026.
//

import Foundation
import DomainInterface

public final class DeleteToDoUseCase: DeleteToDoUseCaseProtocol {
    private let repository: ToDoRepositoryProtocol

    public init(repository: ToDoRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(id: Int) async throws {
        try await repository.deleteToDo(id: id)
    }
}
