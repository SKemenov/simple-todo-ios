//
//  CompleteToDoUseCase.swift
//  ToDoUseCases
//
//  Created by Sergey Kemenov on 17.02.2026.
//

import Foundation
import DomainInterface

public final class CompleteToDoUseCase: CompleteToDoUseCaseProtocol {
    private let repository: ToDoRepositoryProtocol
    private let validator = ToDoDomainValidator()

    public init(repository: ToDoRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(id: UUID, isCompleted: Bool) async throws {
        guard let oldToDo = try await repository.getToDo(id: id) else { return }
        let toDo = DomainModel.ToDo(
                id: id,
                dtoId: oldToDo.dtoId,
                todoTitle: oldToDo.todoTitle,
                todoDescription: oldToDo.todoDescription,
                createAt: oldToDo.createAt,
                isCompleted: isCompleted,
                userId: oldToDo.userId
            )
        try await repository.updateToDo(toDo)
    }
}
