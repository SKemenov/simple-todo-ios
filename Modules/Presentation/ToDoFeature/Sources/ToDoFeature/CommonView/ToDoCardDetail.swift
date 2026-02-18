//
//  ToDoCardDetail.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 16.02.2026.
//

import SwiftUI
import DesignSystem

public struct ToDoCardDetail: View {
    let toDo: UIModel.ToDo

    public init(_ toDo: UIModel.ToDo) {
        self.toDo = toDo
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: .DS.Spacing.xSmall) {
            header
            if !toDo.description.isEmpty {
                secondaryText(toDo.description)
                    .setLinesLimit()
            }
            secondaryText(toDo.createAt)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension ToDoCardDetail {
    var header: some View {
        Text(toDo.title)
            .foregroundStyle(.designSystem(.text(toDo.isCompleted ? .secondary : .primary)))
            .strikethrough(toDo.isCompleted, color: .designSystem(.text(.secondary)))
            .font(.designSystem(.headline))
            .setLinesLimit()
    }

    func secondaryText(_ text: String) -> some View {
        Text(text)
            .foregroundStyle(.designSystem(.text(.secondary)))
            .font(.designSystem(.caption))
    }
}

private extension View {
    func setLinesLimit(_ lines: Int = 2) -> some View {
        self
            .lineLimit(lines)
    }
}
