//
//  DSEmptyState.swift
//  DesignSystem
//
//  Created by Sergey Kemenov on 08.02.2026.
//

import SwiftUI

public struct DSEmptyState: View {
    private let isSearch: Bool

    public init(isSearch: Bool = false) {
        self.isSearch = isSearch
    }

    public var body: some View {
        VStack(spacing: .DS.Spacing.xLarge) {
            icon
            title
            subTitle
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
        Text(isSearch ? .dsEmptySearchTitle : .dsEmptyStateTitle)
            .font(.designSystem(.headline))
            .foregroundColor(.designSystem(.text(.primary)))
    }

    var subTitle: some View {
        Group {
            isSearch
                ? Text(.dsEmptySearchDescription)
                : Text(stateDescKey, bundle: .module) // LocalizedStringKey, exception
        }
            .font(.designSystem(.body))
            .foregroundColor(.designSystem(.text(.secondary)))
            .multilineTextAlignment(.center)
    }

    /// Use LocalizedStringKey instead of LocalizedStringResource to correctly wrap SF symbol in this sentence
    var stateDescKey: LocalizedStringKey {
        "dsEmptyStateDesc\(symbol)"
    }

    /// Wrap Image into Text to apply style
    var symbol: Text {
        Text(
            Image(systemName: .DS.Icons.create)
        )
        .font(.designSystem(.headline))
        .foregroundColor(.designSystem(.text(.accent)))
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
