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
    private(set) var dependencyContainer: DependencyContainer
    @StateObject private var coordinator: AppCoordinator
    private let persistence: PersistenceController

    init () {
        let container = DependencyContainer()
        dependencyContainer = container
        _coordinator = StateObject(wrappedValue: AppCoordinator(container: container))
        persistence = container.persistenceController
        Logger.core.info("\(String.logHeader()) App started")
    }

    var body: some Scene {
        WindowGroup {
            AppCoordinatorView()
                .environmentObject(coordinator)
                .environment(\.managedObjectContext, persistence.mainViewContext)
                .preferredColorScheme(.dark)
                .onAppear {
                    UIView.appearance().tintColor = UIColor(Color.designSystem(.text(.accent)))
                }
        }
    }
}
