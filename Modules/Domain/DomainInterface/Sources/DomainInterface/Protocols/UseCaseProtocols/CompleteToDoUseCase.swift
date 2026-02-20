//
//  CompleteToDoUseCaseProtocol.swift
//  DomainInterface
//
//  Created by Sergey Kemenov on 17.02.2026.
//

import Foundation

public protocol CompleteToDoUseCaseProtocol {
    func execute(id: UUID, isCompleted: Bool) async throws
}
