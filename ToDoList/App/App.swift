//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Sergey Kemenov on 07.02.2026.
//

import SwiftUI
import DesignSystem
import Logging
import ToDoFeature
import Utilities
import CoreData
import LocalStores

@main
struct ToDoListApp: App {
    @StateObject private var dependencyContainer: DependencyContainer
    @StateObject private var coordinator: AppCoordinator
    private let persistence: PersistenceController

    init () {
        let container = DependencyContainer()
        _dependencyContainer = StateObject(wrappedValue: container)
        _coordinator = StateObject(wrappedValue: AppCoordinator(dependencyContainer: container))
        persistence = container.persistenceController
        UIView.appearance().tintColor = UIColor(Color.designSystem(.text(.accent)))
        Logger.core.info("\(Current.logHeader()) App started")
    }

    var body: some Scene {
        WindowGroup {
            AppCoordinatorView()
                .environmentObject(coordinator)
                .environmentObject(dependencyContainer)
                .environment(\.managedObjectContext, persistence.container.viewContext)
                .preferredColorScheme(.dark)
        }
    }
}
