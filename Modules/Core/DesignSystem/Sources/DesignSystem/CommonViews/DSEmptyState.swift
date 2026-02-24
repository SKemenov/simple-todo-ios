//
//  DSEmptyState.swift
//  DesignSystem
//
//  Created by Sergey Kemenov on 08.02.2026.
//

import SwiftUI

public struct DSEmptyState: View {
    private let emptyTitle: LocalizedStringKey = "No ToDos yet"
    private let emptyTap: LocalizedStringKey = "Tap the"
    private let emptyDescription: LocalizedStringKey = "button to create your first ToDo"
    private let searchTitle: LocalizedStringKey = "Not Found"
    private let searchDescription: LocalizedStringKey = "Try to search another one"
    private let isSearch: Bool

    public init(isSearch: Bool = false) {
        self.isSearch = isSearch
    }

    public var body: some View {
        VStack(spacing: .DS.Spacing.xLarge) {
            icon

            title

            if isSearch {
                searchDesc
            } else {
                emptyDesc
            }
        }
        .padding()
        .padding(.bottom, .DS.Sizes.footer)
        .background(.designSystem(.background(.primary)))
    }
}

private extension DSEmptyState {
    var icon: some View {
        Image.DS.Icons.empty
            .font(.designSystem(.iconLarge))
            .foregroundColor(.designSystem(.text(.secondary)))
    }

    var title: some View {
        Text(isSearch ? searchTitle : emptyTitle, bundle: .module)
            .font(.designSystem(.headline))
            .foregroundColor(.designSystem(.text(.primary)))
    }

    var emptyDesc: some View {
        HStack(spacing: .DS.Spacing.xxSmall) {
            Text(emptyTap, bundle: .module)
            Image.DS.Icons.create.foregroundColor(.designSystem(.text(.accent)))
            Text(emptyDescription, bundle: .module)
        }
        .font(.designSystem(.body))
        .foregroundColor(.designSystem(.text(.secondary)))
        .multilineTextAlignment(.center)
    }

    var searchDesc: some View {
        Text(searchDescription, bundle: .module)
            .font(.designSystem(.body))
            .foregroundColor(.designSystem(.text(.secondary)))
            .multilineTextAlignment(.center)
    }
}

#Preview("Empty State - English") {
    DSEmptyState()
        .preferredColorScheme(.dark)
        .environment(\.locale, Locale(identifier: "EN"))
}

#Preview("Empty State - Russian") {
    DSEmptyState()
        .preferredColorScheme(.dark)
        .environment(\.locale, Locale(identifier: "RU"))
}

#Preview("Empty Search - English") {
    DSEmptyState(isSearch: true)
        .preferredColorScheme(.dark)
        .environment(\.locale, Locale(identifier: "EN"))
}

#Preview("Empty Search - Russian") {
    DSEmptyState(isSearch: true)
        .preferredColorScheme(.dark)
        .environment(\.locale, Locale(identifier: "RU"))
}
