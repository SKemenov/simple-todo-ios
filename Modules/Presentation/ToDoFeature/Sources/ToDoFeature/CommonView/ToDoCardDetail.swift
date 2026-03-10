//
//  ToDoCardDetail.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 16.02.2026.
//

import SwiftUI
import DesignSystem

public struct ToDoCardDetail: View, Equatable {
    let toDo: UIModel.ToDo
    let onDelete: () -> Void
    @EnvironmentObject private var coordinator: AppCoordinator

    public init(_ toDo: UIModel.ToDo, onDelete: @escaping () -> Void) {
        self.toDo = toDo
        self.onDelete = onDelete
    }

    public var body: some View {
        content
            .contentShape(.contextMenuPreview, Rectangle())
            .onTapGesture(perform: openDetail)
            .contextMenu {
                Button(.globalEdit, systemImage: .DS.Icons.edit, action: openDetail)
                ShareLink(.globalShare, item: toDo.exportAsString)
                Button(.globalDelete, systemImage: .DS.Icons.delete, role: .destructive, action: onDelete)
            }
    }

    public static func == (lhs: ToDoCardDetail, rhs: ToDoCardDetail) -> Bool {
        lhs.toDo == rhs.toDo
    }
}

private extension ToDoCardDetail {
    @ViewBuilder var content: some View {
        VStack(alignment: .leading, spacing: .DS.Spacing.xSmall) {
            header
            if !toDo.description.isEmpty {
                secondaryText(toDo.description)
                    .setLinesLimit()
            }
            secondaryText(toDo.createAt)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }

    @ViewBuilder var header: some View {
        Text(toDo.title)
            .foregroundStyle(.designSystem(.text(toDo.isCompleted ? .secondary : .primary)))
            .strikethrough(toDo.isCompleted, color: .designSystem(.text(.secondary)))
            .font(.designSystem(.headline))
            .setLinesLimit()
    }

    @ViewBuilder
    func secondaryText(_ text: String) -> some View {
        Text(text)
            .foregroundStyle(.designSystem(.text(.secondary)))
            .font(.designSystem(.caption))
    }

    func openDetail() {
        coordinator.push(page: .toDoDetail(model: toDo))
    }
}

private extension View {
    func setLinesLimit(_ lines: Int = 2) -> some View {
        self
            .lineLimit(lines)
    }
}

#Preview {
    ToDoCardDetail(
        UIModel.ToDo(
            id: UUID(),
            title: "Task",
            description: "some description",
            createAt: Date().createDateStamp(),
            isCompleted: false
        ),
        onDelete: {}
    )
    .preferredColorScheme(.dark)
}
