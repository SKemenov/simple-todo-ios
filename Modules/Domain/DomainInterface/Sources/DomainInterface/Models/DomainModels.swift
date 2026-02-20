//
//  DomainModels.swift
//  DomainInterface
//
//  Created by Sergey Kemenov on 09.02.2026.
//

import Foundation
import Utilities

public enum DomainModel {
}

extension DomainModel {
    public struct ToDo: Identifiable, Equatable, Hashable, CustomStringConvertible {
        public var id: UUID
        public var dtoId: Int?
        public var todoTitle: String
        public var todoDescription: String
        public var createAt: Date
        public var isCompleted: Bool
        public var userId: Int

        public init(
            id: UUID = UUID(),
            dtoId: Int? = nil,
            todoTitle: String,
            todoDescription: String = "",
            createAt: Date = Current.date(),
            isCompleted: Bool = false,
            userId: Int = 1
        ) {
            self.id = id
            self.dtoId = dtoId
            self.todoTitle = todoTitle
            self.todoDescription = todoDescription
            self.createAt = createAt
            self.isCompleted = isCompleted
            self.userId = userId
        }

        public var description: String {
            "DomainModel.ToDo(id: \(id), DTO id: \(dtoId ?? -1), title: \(todoTitle), description: \(todoDescription)"
            + ", isCompleted: \(isCompleted))"
        }
    }
}
