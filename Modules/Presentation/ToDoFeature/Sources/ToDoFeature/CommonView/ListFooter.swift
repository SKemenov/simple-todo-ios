//
//  ListFooter.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 24.02.2026.
//

import SwiftUI
import DesignSystem

struct ListFooter: View {
    var counter: Int
    var onCreate: () -> Void

    init(counter: Int, onCreate: @escaping () -> Void) {
        self.counter = counter
        self.onCreate = onCreate
    }

    var body: some View {
        HStack {
            Spacer()
            totalCount
            Spacer()
        }
        .padding(.vertical, .DS.Spacing.xxLarge)
        .background(.designSystem(.background(.secondary)))
        .overlay(alignment: .trailing) { createButton }
    }
}

private extension ListFooter {
    var createButton: some View {
        Button(action: onCreate) {
            Image.DS.Icons.create
                .font(.designSystem(.title))
                .foregroundStyle(.designSystem(.text(.accent)))
        }
        .padding()
    }

    var totalCount: some View {
        Text(.footerCounter(counter))
            .font(.designSystem(.caption))
            .foregroundStyle(.designSystem(.text(.primary)))
    }
}

#if DEBUG
#Preview("List Footer - Russian") {
    ListFooter(counter: 31) { print("tapped") }
        .preferredColorScheme(.dark)
        .environment(\.locale, Locale(identifier: "RU"))
}
#Preview("List Footer - English") {
    ListFooter(counter: 21) { print("tapped") }
        .preferredColorScheme(.dark)
        .environment(\.locale, Locale(identifier: "EN"))
}
#endif
