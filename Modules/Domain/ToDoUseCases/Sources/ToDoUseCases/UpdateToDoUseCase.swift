//
//  UpdateToDoUseCase.swift
//  ToDoUseCases
//
//  Created by Sergey Kemenov on 10.02.2026.
//

import Foundation
import DomainInterface

public final class UpdateToDoUseCase: UpdateToDoUseCaseProtocol {
    private let repository: ToDoRepositoryProtocol
    private let validator = ToDoDomainValidator()

    public init(repository: ToDoRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(id: UUID, title: String, description: String) async throws {
        var checkedTitle = validator.validateTitle(title)
        var checkedDescription = validator.validateDescription(description)

        guard !checkedTitle.isEmpty, !checkedDescription.isEmpty else {
            return // Nothing to update
        }
        if checkedTitle.isEmpty {
            checkedTitle = checkedDescription
            checkedDescription = ""
        }
        let oldToDo = try await repository.getToDo(id: id)
        let toDo: DomainModel.ToDo
        if let oldToDo {
            toDo = DomainModel.ToDo(
                id: id,
                dtoId: oldToDo.dtoId,
                todoTitle: checkedTitle,
                todoDescription: checkedDescription,
                createAt: oldToDo.createAt,
                isCompleted: oldToDo.isCompleted,
                userId: oldToDo.userId
            )
        } else {
            toDo = DomainModel.ToDo(
                id: id,
                todoTitle: checkedTitle,
                todoDescription: checkedDescription
            )
        }
        try await repository.updateToDo(toDo)
    }
}
