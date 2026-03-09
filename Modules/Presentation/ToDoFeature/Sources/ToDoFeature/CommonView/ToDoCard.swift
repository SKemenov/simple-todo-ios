//
//  ToDoRowView.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 10.02.2026.
//

import SwiftUI
import DesignSystem

public struct ToDoCard: View, Equatable {
    let toDo: UIModel.ToDo
    let onComplete: () -> Void
    let onDelete: () -> Void
    private let isLast: Bool

    public static func == (lhs: ToDoCard, rhs: ToDoCard) -> Bool {
        lhs.toDo == rhs.toDo && lhs.isLast == rhs.isLast
    }

    public init(_ toDo: UIModel.ToDo, isLast: Bool, onComplete: @escaping () -> Void, onDelete: @escaping () -> Void) {
        self.toDo = toDo
        self.onComplete = onComplete
        self.onDelete = onDelete
        self.isLast = isLast
    }

    public var body: some View {
        VStack(spacing: .zero) {
            DSRow(
                leading: { Button(action: onComplete) { DSToggle(isSelected: toDo.isCompleted) } },
                trailing: { ToDoCardDetail(toDo, onDelete: onDelete) }
            )
            .dsRowPrimaryElement(.trailing)
            .dsRowSpacing(.DS.Spacing.xxSmall)
            .padding(.vertical, .DS.Spacing.large)

            divider
        }
        .padding(.horizontal, .DS.Spacing.xxLarge)
        .background(.designSystem(.background(.primary)))
    }
}

private extension ToDoCard {
    @ViewBuilder var divider: some View {
        if !isLast {
            Rectangle()
                .fill(.designSystem(.border(.primary)))
                .frame(height: .DS.Borders.small)
        }
    }
}

#if DEBUG
#Preview {
    ToDoCard(
        UIModel.ToDo(
            id: UUID(),
            title: "Task",
            description: "some description",
            createAt: Date().createDateStamp(),
            isCompleted: false
        ),
        isLast: false,
        onComplete: {},
        onDelete: {}
    )
    .environmentObject(AppCoordinator(container: UIMockAppDIContainer()))
    .preferredColorScheme(.dark)
}
#endif
