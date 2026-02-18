//
//  GetAllToDosUseCase.swift
//  DomainInterface
//
//  Created by Sergey Kemenov on 09.02.2026.
//

import Foundation

public protocol GetAllToDosUseCaseProtocol {
    func execute() async throws -> [DomainModel.ToDo]
}
