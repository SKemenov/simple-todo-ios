//
//  ToDoRowView.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 10.02.2026.
//

import SwiftUI
import DesignSystem

public struct ToDoCard: View {
    let toDo: UIModel.ToDo
    let action: () -> Void
    private let isLast: Bool
    @EnvironmentObject private var coordinator: AppCoordinator

    public init(_ toDo: UIModel.ToDo, isLast: Bool, action: @escaping () -> Void) {
        self.toDo = toDo
        self.action = action
        self.isLast = isLast
    }

    public var body: some View {
        VStack(spacing: .zero) {
            DSRow(
                leading: { completeButton },
                trailing: { detail }
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
    var completeButton: some View {
        Button(action: action) {
            DSToggle(isSelected: toDo.isCompleted)
        }
    }

    var detail: some View {
        ToDoCardDetail(toDo)
            .contentShape(Rectangle())
            .onTapGesture {
                coordinator.push(page: .toDoDetail(model: toDo))
            }
    }

    @ViewBuilder
    var divider: some View {
        if !isLast {
            Rectangle()
                .fill(.designSystem(.border(.primary)))
                .frame(height: .DS.Borders.small)
        }
    }
}

#if DEBUG
#Preview {
    ToDoCard(UIModel.ToDo(
        id: UUID(),
        title: "Task",
        description: "some description",
        createAt: Date().createDateStamp(),
        isCompleted: false
    ), isLast: false, action: {})
    .environmentObject(AppCoordinator(container: UIMockDependencyContainer()))
    .preferredColorScheme(.dark)
}
#endif
