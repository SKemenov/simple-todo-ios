//
//  RootScreen.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 17.02.2026.
//

import SwiftUI
import DesignSystem

public struct RootScreen: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var vm: RootViewModel

    private let titlePrompt: LocalizedStringKey = "There's a root view."
    private let descriptionPrompt: LocalizedStringKey = "rootView.detailDescription"

    public init(vm: RootViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    public var body: some View {
        VStack(spacing: .DS.Spacing.xxLarge) {
            Image.DS.Icons.warning
                .font(.designSystem(.iconLarge))
                .foregroundColor(.designSystem(.text(.accent)))

            showText(titlePrompt)
            showText(descriptionPrompt)

            Button("Open ToDoList", action: openList)
                .buttonStyle(.bordered)
                .foregroundColor(.designSystem(.text(.accent)))

            Button("Clear CoreData (no confirmation)", action: clearCoreData)
                .buttonStyle(.bordered)
                .foregroundColor(.designSystem(.text(.accent)))

            showText("CoreData has \(vm.totalCount) records.")

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.designSystem(.background(.primary)))
        .task {
            await vm.loadData()
        }
    }

}

private extension RootScreen {
    func showText(_ string: LocalizedStringKey) -> some View {
        Text(string, bundle: .module)
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
