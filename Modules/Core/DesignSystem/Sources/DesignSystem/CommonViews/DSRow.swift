//
//  DSRow.swift
//  DesignSystem
//
//  Created by Sergey Kemenov on 08.02.2026.
//

import SwiftUI

public struct DSRow<Leading: View, Trailing: View>: View {
    @ViewBuilder public var leading: Leading
    @ViewBuilder public var trailing: Trailing

    @Environment(\.configuration.row) private var configuration

    private var leadingMaxWidth: CGFloat? {
        configuration.primaryElement == .leading || configuration.primaryElement == .both ? .infinity : nil
    }

    private var trailingMaxWidth: CGFloat? {
        configuration.primaryElement == .trailing || configuration.primaryElement == .both ? .infinity : nil
    }

    private var padding: CGFloat {
        configuration.style == .plain ? .zero : .DS.Spacing.medium
    }

    public init(
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing = EmptyView.init
    ) {
        self.leading = leading()
        self.trailing = trailing()
    }

   public var body: some View {
       HStack(alignment: configuration.verticalAlignment, spacing: configuration.spacing) {
            leading
                .frame(maxWidth: leadingMaxWidth, alignment: .leading)

            trailing
                .frame(maxWidth: trailingMaxWidth, alignment: .trailing)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(padding)
    }
}

public enum DSRowStyle {
    case plain
    case inset
}

public enum DSRowPrimary {
    case leading
    case trailing
    case both
}

public extension DSRow where Leading == Never, Trailing == Never {
    struct Configuration {
        var style: DSRowStyle = .plain
        var spacing: CGFloat = .DS.Spacing.small
        var primaryElement: DSRowPrimary = .leading
        var verticalAlignment: VerticalAlignment = .top
    }
}

public extension View {
    func dsRowStyle(_ style: DSRowStyle) -> some View {
        environment(\.configuration.row.style, style)
    }

    func dsRowSpacing(_ spacing: CGFloat) -> some View {
        environment(\.configuration.row.spacing, spacing)
    }

    func dsRowPrimaryElement(_ element: DSRowPrimary) -> some View {
        environment(\.configuration.row.primaryElement, element)
    }
}

#Preview {
    VStack(spacing: 20) {
        DSRow(
            leading: { Text("Hello").background(Color.green.opacity(0.25)) },
            trailing: { DSToggle(isSelected: true).background(Color.green.opacity(0.25)) }
        )
        .background(Color.blue.opacity(0.25))

        DSRow(
            leading: { Text("Hello Hello Hello Hello Hello Hello Hello Hello Hello") },
            trailing: { DSToggle(isSelected: true).background(Color.green.opacity(0.25)) }
        )
        .dsRowStyle(.inset)
        .dsRowSpacing(.DS.Spacing.xxLarge)
        .background(Color.blue.opacity(0.25))

        DSRow(
            leading: { Text("Hello Hello Hello Hello Hello Hello Hello").background(Color.green.opacity(0.25)) },
            trailing: { Text("world").background(Color.green.opacity(0.25)) }
        )
        .dsRowStyle(.inset)
        .background(Color.blue.opacity(0.25))

        DSRow(
            leading: { Text("Hello Hello Hello Hello Hello Hello Hello").background(Color.green.opacity(0.25)) },
            trailing: { Text("world").background(Color.green.opacity(0.25)) }
        )
        .dsRowPrimaryElement(.both)
        .background(Color.blue.opacity(0.25))

        DSRow(
            leading: { Text("Hello").background(Color.green.opacity(0.25)) },
            trailing: { Text("world world world world world world world").background(Color.green.opacity(0.25)) }
        )
        .dsRowStyle(.inset)
        .dsRowPrimaryElement(.trailing)
        .background(Color.blue.opacity(0.25))

    }
    .padding()
    .preferredColorScheme(.dark)
}
