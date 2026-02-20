//
//  CreateToDoUseCase.swift
//  ToDoUseCases
//
//  Created by Sergey Kemenov on 10.02.2026.
//

import Foundation
import DomainInterface

public final class CreateToDoUseCase: CreateToDoUseCaseProtocol {
    private let repository: ToDoRepositoryProtocol
    private let validator = ToDoDomainValidator()

    public init(repository: ToDoRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(title: String, description: String) async throws {
        var checkedTitle = validator.validateTitle(title)
        var checkedDescription = validator.validateDescription(description)

        if checkedTitle.isEmpty {
            checkedTitle = checkedDescription
            checkedDescription = ""
        }

        let toDo = DomainModel.ToDo(
            todoTitle: checkedTitle,
            todoDescription: checkedDescription
        )
        try await repository.createToDo(toDo)
    }
}
