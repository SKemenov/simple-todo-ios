//
//  DSError.swift
//  DesignSystem
//
//  Created by Sergey Kemenov on 08.02.2026.
//

import SwiftUI

public struct DSError: View {
    let icon: Image
    let message: String
    let retry: (@Sendable () async -> Void)?
    let dismiss: @Sendable () async -> Void

    public init(
        icon: Image = .DS.Icons.warning,
        message: String,
        retry: (@Sendable () async -> Void)? = nil,
        dismiss: @escaping @Sendable () async -> Void
    ) {
        self.icon = icon
        self.message = message
        self.retry = retry
        self.dismiss = dismiss
    }

    public var body: some View {
        VStack(spacing: .DS.Spacing.xLarge) {
            icon
                .font(.designSystem(.iconLarge))
                .foregroundColor(.designSystem(.text(.error)))

            Text(message)
                .font(.designSystem(.body))
                .foregroundColor(.designSystem(.text(.primary)))
                .multilineTextAlignment(.center)

            if let retry {
                Button {
                    Task {
                        await dismiss()
                        await retry()
                    }
                } label: {
                    Text(.globalRetry)
                }
                    .buttonStyle(.bordered)
                    .foregroundColor(.designSystem(.text(.accent)))
                    .padding()
            } else {
                Button {
                    Task { await dismiss() }
                } label: {
                    Text(verbatim: "OK")
                }
                    .buttonStyle(.bordered)
                    .foregroundColor(.designSystem(.text(.accent)))
                    .padding()
            }
        }
        .padding()
        .background(.designSystem(.background(.primary)))
    }
}

#Preview("Error with Retry - Russian") {
    DSError(
        message: "Пример ошибки",
        retry: { print("retry tapped") },
        dismiss: { print("dismiss tapped") }
    )
    .preferredColorScheme(.dark)
    .environment(\.locale, Locale(identifier: "RU"))
}

#Preview("Error with Retry - English") {
    DSError(
        message: "Sample Error",
        retry: { print("retry tapped") },
        dismiss: { print("dismiss tapped") }
    )
    .preferredColorScheme(.dark)
    .environment(\.locale, Locale(identifier: "EN"))
}

#Preview("Error with OK - Russian") {
    DSError(
        message: "Пример ошибки",
        dismiss: { print("dismiss tapped") }
    )
    .preferredColorScheme(.dark)
    .environment(\.locale, Locale(identifier: "RU"))
}

#Preview("Error with OK - English") {
    DSError(message: "Sample Error", dismiss: { print("dismiss tapped") })
        .preferredColorScheme(.dark)
        .environment(\.locale, Locale(identifier: "EN"))
}
