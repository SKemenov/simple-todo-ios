//
//  DSError.swift
//  DesignSystem
//
//  Created by Sergey Kemenov on 08.02.2026.
//

import SwiftUI

public struct DSError: View {
    let message: String
    let retry: () -> Void

    public init(message: String, retry: @escaping () -> Void) {
        self.message = message
        self.retry = retry
    }

    public var body: some View {
        VStack(spacing: .DS.Spacing.xLarge) {
            Image.DS.Icons.warning
                .font(.designSystem(.iconLarge))
                .foregroundColor(.designSystem(.text(.error)))

            Text(message)
                .font(.designSystem(.body))
                .foregroundColor(.designSystem(.text(.primary)))
                .multilineTextAlignment(.center)

            Button(action: retry) {
                Text("Retry", bundle: .module)
            }
                .buttonStyle(.bordered)
                .foregroundColor(.designSystem(.text(.accent)))
                .padding()
        }
        .padding()
        .background(.designSystem(.background(.primary)))
    }
}

#Preview {
    DSError(message: "Sample Error", retry: { print("button tapped") })
        .preferredColorScheme(.dark)
        .environment(\.locale, Locale(identifier: "RU"))
}
