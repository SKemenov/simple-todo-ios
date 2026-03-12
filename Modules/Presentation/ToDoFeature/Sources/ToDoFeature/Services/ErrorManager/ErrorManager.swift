//
//  ErrorManager.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 03.03.2026.
//

import SwiftUI

// MARK: - ErrorManager

public final class ErrorManager: ObservableObject {
    @Published public var errors: [UIModel.AppError] = []

    public var currentError: UIModel.AppError? { errors.first }

    public init() {}

    @MainActor
    public func show(
        _ message: String,
        kind: UIModel.AppError.Kind = .general,
        retry: (@Sendable () async -> Void)? = nil
    ) {
        errors.append(UIModel.AppError(kind: kind, message: message, retry: retry))
    }

    @MainActor
    public func dismiss() {
        guard !errors.isEmpty else { return }
        errors.removeFirst()
    }
}
