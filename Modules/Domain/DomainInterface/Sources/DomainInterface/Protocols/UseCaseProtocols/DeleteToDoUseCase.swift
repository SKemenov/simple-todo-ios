//
//  DeleteToDoUseCase.swift
//  DomainInterface
//
//  Created by Sergey Kemenov on 09.02.2026.
//

import Foundation

public protocol DeleteToDoUseCaseProtocol {
    func execute(id: UUID) async throws
}
