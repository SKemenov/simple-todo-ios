//
//  MockToDosUseCases.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 20.02.2026.
//

import Testing
@testable import ToDoFeature
import DomainInterface
import Foundation

class MockGetAllToDosUseCase: GetAllToDosUseCaseProtocol {
    var result: [DomainModel.ToDo] = []
    var shouldThrow = false

    func execute() async throws -> [DomainModel.ToDo] {
        if shouldThrow { throw NSError(domain: "TestError", code: -1) }
        return result
    }
}

class MockCreateToDoUseCase: CreateToDoUseCaseProtocol {
    var callCount = 0
    var lastTitle: String?
    var lastDescription: String?

    func execute(title: String, description: String) async throws {
        callCount += 1
        lastTitle = title
        lastDescription = description
    }
}

class MockUpdateToDoUseCase: UpdateToDoUseCaseProtocol {
    var callCount = 0
    var lastId: UUID?
    var lastTitle: String?
    var lastDescription: String?

    func execute(id: UUID, title: String, description: String) async throws {
        callCount += 1
        lastId = id
        lastTitle = title
        lastDescription = description
    }
}

class MockCompleteToDoUseCase: CompleteToDoUseCaseProtocol {
    var callCount = 0
    var lastId: UUID?
    var lastIsCompleted: Bool?

    func execute(id: UUID, isCompleted: Bool) async throws {
        callCount += 1
        lastId = id
        lastIsCompleted = isCompleted
    }
}

class MockDeleteToDoUseCase: DeleteToDoUseCaseProtocol {
    var callCount = 0
    var lastId: UUID?

    func execute(id: UUID) async throws {
        callCount += 1
        lastId = id
    }
}
