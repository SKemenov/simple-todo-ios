//
//  UpdateToDoUseCase.swift
//  DomainInterface
//
//  Created by Sergey Kemenov on 09.02.2026.
//

import Foundation

public protocol UpdateToDoUseCaseProtocol {
    func execute(id: Int, title: String, description: String) async throws
}
