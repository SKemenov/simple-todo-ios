//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Sergey Kemenov on 05.02.2026.
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
    private let container: AppDIContainer
    @StateObject private var coordinator: AppCoordinator
    @StateObject private var errorManager: ErrorManager
    @StateObject private var networkState: NetworkState

    init () {
        let errors = ErrorManager()
        let networkState = NetworkState()
        let appDIContainer = AppDIContainer(errorManager: errors, networkState: networkState)
        container = appDIContainer
        _coordinator = StateObject(wrappedValue: AppCoordinator(container: appDIContainer))
        _errorManager = StateObject(wrappedValue: errors)
        _networkState = StateObject(wrappedValue: networkState)
        Logger.core.info("\(String.logHeader()) App started")
    }

    var body: some Scene {
        WindowGroup {
            AppCoordinatorView()
                .environmentObject(coordinator)
                .environmentObject(errorManager)
                .environmentObject(networkState)
                .preferredColorScheme(.dark)
                .onAppear {
                    UIView.appearance().tintColor = UIColor(Color.designSystem(.text(.accent)))
                }
        }
    }
}
