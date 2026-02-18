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

public final class AppCoordinator: ObservableObject {
    public private(set) var dependencyContainer: GetFeatureViewModelsProtocol

    @Published var path: NavigationPath = NavigationPath()
    // No need to implement .sheet and .fullScreenCover for this app
    @Published var isNeedToShowList: Bool = false

    public init(dependencyContainer: GetFeatureViewModelsProtocol) {
        self.dependencyContainer = dependencyContainer
        Logger.core.info("\(Current.logHeader()) Started")
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
            RootScreen(vm: dependencyContainer.makeRootViewModel())

        case .toDosList:
            ToDoListScreen(vm: dependencyContainer.makeToDoListViewModel())

        case .createToDo:
            ToDoDetailScreen(vm: dependencyContainer.makeToDoDetailViewModel())

        case let .toDoDetail(model: model):
            ToDoDetailScreen(vm: dependencyContainer.makeToDoDetailViewModel(), model: model)
        }
    }
}
