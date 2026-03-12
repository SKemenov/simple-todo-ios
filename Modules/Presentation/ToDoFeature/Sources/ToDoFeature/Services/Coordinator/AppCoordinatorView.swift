//
//  AppCoordinatorView.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 10.02.2026.
//

import SwiftUI
import DesignSystem

public struct AppCoordinatorView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var errorManager: ErrorManager
    @EnvironmentObject private var networkState: NetworkState

    public init() {}

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: coordinator.isNeedToShowList ? .toDosList : .root)
                .navigationDestination(for: AppPages.self) { page in
                    coordinator.build(page: page)
                }
        }
        .spinner(isPresented: !networkState.loadingStates.isEmpty)
        .overlay { errorOverlay }
    }
}

private extension AppCoordinatorView {
    @ViewBuilder var errorOverlay: some View {
        if let appError = errorManager.currentError {
            DSError(
                icon: icon(for: appError.kind),
                message: appError.message,
                retry: appError.retry,
                dismiss: { [errorManager] in
                    await MainActor.run { errorManager.dismiss() }
                }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.designSystem(.background(.primary)))
            .transition(.opacity)
        }
    }

    func icon(for kind: UIModel.AppError.Kind) -> Image {
        switch kind {
        case .network: .DS.Icons.network
        case .storage: .DS.Icons.storage
        case .general: .DS.Icons.warning
        }
    }
}
