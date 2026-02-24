//
//  AppCoordinatorView.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 10.02.2026.
//

import SwiftUI

public struct AppCoordinatorView: View {
    @EnvironmentObject private var coordinator: AppCoordinator

    public init() {}
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: coordinator.isNeedToShowList ? .toDosList : .root)
                .navigationDestination(for: AppPages.self) { page in
                    coordinator.build(page: page)
                }
        }
    }
}
