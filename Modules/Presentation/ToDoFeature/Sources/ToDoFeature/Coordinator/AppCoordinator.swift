//
//  AppCoordinator.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 10.02.2026.
//

import SwiftUI
import Combine
import DomainInterface
import Logging
import Utilities

@MainActor
public final class AppCoordinator: ObservableObject {
    public let container: GetFeatureViewModelsProtocol

    @Published public var path: NavigationPath = NavigationPath()
    // No need to implement .sheet and .fullScreenCover for this app
    @Published public var isNeedToShowList: Bool = false

    public init(container: GetFeatureViewModelsProtocol) {
        self.container = container
        Logger.core.info("\(String.logHeader()) Started")
    }
}

// MARK: - `Page` methods
public extension AppCoordinator {
    func push(page: AppPages) {
        path.append(page)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    @ViewBuilder
    func build(page: AppPages) -> some View {
        switch page {
        case .root:
            RootScreen(vm: container.makeRootViewModel())

        case .toDosList:
            ToDoListScreen(vm: container.makeToDoListViewModel())

        case .createToDo:
            ToDoDetailScreen(vm: container.makeToDoDetailViewModel())

        case let .toDoDetail(model: model):
            ToDoDetailScreen(vm: container.makeToDoDetailViewModel(), model: model)
        }
    }
}
