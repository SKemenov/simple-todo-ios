//
//  DSToggle.swift
//  DesignSystem
//
//  Created by Sergey Kemenov on 08.02.2026.
//

import SwiftUI

public struct DSToggle: View {
    private var isSelected: Bool
    @Environment(\.isEnabled) private var isEnabled

    public init(isSelected: Bool) {
        self.isSelected = isSelected
    }

    public var body: some View {
        ZStack {
            incompleteLayer
                .opacity(isSelected ? 0 : 1)
                .scaleEffect(isSelected ? 0.5 : 1)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isSelected)
            completeLayer
                .opacity(isSelected ? 1 : 0)
                .scaleEffect(isSelected ? 1 : 0.5)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isSelected)
            disabledLayer
                .opacity(!isEnabled ? 0.25 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isEnabled)
        }
        .background(.designSystem(.background(.primary)))
    }
}

private extension DSToggle {
    var incompleteLayer: some View {
        Image.DS.Icons.incomplete
            .font(.designSystem(.icon))
            .foregroundStyle(.designSystem(.border(.primary)))
    }

    var completeLayer: some View {
        Image.DS.Icons.complete
            .font(.designSystem(.icon))
            .foregroundStyle(.designSystem(.text(.accent)))

    }

    var disabledLayer: some View {
        Circle()
            .fill(.designSystem(.text(.secondary)))
            .frame(width: .DS.Sizes.icon)
    }
}


#Preview {
    VStack(alignment: .leading, spacing: .DS.Spacing.small) {
        DSRow(leading: { Text("not selected, enabled") }, trailing: {
            DSToggle(isSelected: false)
        })

        DSRow(leading: { Text("selected, enabled") }, trailing: {
            DSToggle(isSelected: true)
        })
        .padding(.bottom)

        DSRow(leading: { Text("not selected, disabled") }, trailing: {
            DSToggle(isSelected: false).disabled(true)
        })

        DSRow(leading: { Text("selected, disabled") }, trailing: {
            DSToggle(isSelected: true).disabled(true)
        })
    }
    .padding()
    .background(.designSystem(.background(.primary)))
    .preferredColorScheme(.dark)
    .foregroundStyle(.designSystem(.text(.primary)))
}
