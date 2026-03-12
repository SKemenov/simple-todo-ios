//
//  NetworkState.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 03.03.2026.
//

import SwiftUI

// MARK: - NetworkState

public final class NetworkState: ObservableObject {
    public var isLoading: Bool { !loadingStates.isEmpty }

    @Published private(set) var loadingStates: [String: Bool] = [:]

    public init() {}

    @MainActor
    public func set(_ state: Bool, for key: String) {
        loadingStates[key] = state ? state : nil
        print(#fileID, #function, "isLoading [\(isLoading)]")
    }
}
