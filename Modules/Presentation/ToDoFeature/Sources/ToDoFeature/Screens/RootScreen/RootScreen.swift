//
//  RootScreen.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 17.02.2026.
//

import SwiftUI
import DesignSystem
//import DomainInterface

public struct RootScreen: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var vm: RootViewModel

    public init(vm: RootViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    public var body: some View {
        VStack(spacing: .DS.Spacing.xxLarge) {
            Image.DS.Icons.warning
                .font(.designSystem(.iconLarge))
                .foregroundColor(.designSystem(.text(.accent)))

            showText(.rootViewHeader)
            showText(.rootViewDescription)

            Button(.rootViewOpenListButton, action: openList)
                .buttonStyle(.bordered)
                .foregroundColor(.designSystem(.text(.accent)))
                .padding()

            Button(.rootViewClearCoreDataButton, action: clearCoreData)
                .buttonStyle(.bordered)
                .foregroundColor(.designSystem(.text(.accent)))

            showText(.coreDataCounter(vm.totalCount))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.designSystem(.background(.primary)))
        .task {
            await vm.loadData()
        }
    }

}

private extension RootScreen {
    func showText(_ text: LocalizedStringResource) -> some View {
        Text(text)
            .font(.designSystem(.body))
            .foregroundColor(.designSystem(.text(.primary)))
            .multilineTextAlignment(.center)
    }

    func openList() {
        coordinator.isNeedToShowList = true
    }

    func clearCoreData() {
        Task { await vm.clearCache() }
    }
}
#if DEBUG
#Preview("Root - Russian") {
    RootScreen(vm: UIMockDependencyContainer().makeRootViewModel())
        .environmentObject(AppCoordinator(container: UIMockDependencyContainer()))
        .preferredColorScheme(.dark)
        .environment(\.locale, Locale(identifier: "RU"))
}

#Preview("Root - English") {
    RootScreen(vm: UIMockDependencyContainer().makeRootViewModel())
        .environmentObject(AppCoordinator(container: UIMockDependencyContainer()))
        .preferredColorScheme(.dark)
        .environment(\.locale, Locale(identifier: "EN"))
}
#endif
