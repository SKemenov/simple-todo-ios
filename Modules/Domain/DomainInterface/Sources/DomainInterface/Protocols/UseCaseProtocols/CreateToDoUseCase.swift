//
//  CreateToDoUseCase.swift
//  DomainInterface
//
//  Created by Sergey Kemenov on 09.02.2026.
//

import Foundation

public protocol CreateToDoUseCaseProtocol {
    func execute(title: String, description: String) async throws
}
