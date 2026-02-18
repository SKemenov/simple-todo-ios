//
//  UIModel.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 10.02.2026.
//

import Foundation
import DomainInterface
import Utilities

public enum UIModel { }

extension UIModel {
    public struct ToDo: Identifiable, Equatable, Hashable {
        public var id: Int
        public var title: String
        public var description: String
        public var createAt: String
        public var isCompleted: Bool

        public init(id: Int, title: String, description: String, createAt: String, isCompleted: Bool) {
            self.id = id
            self.title = title
            self.description = description
            self.createAt = createAt
            self.isCompleted = isCompleted
        }

        public var searchable: String {
            "\(title) \(description) \(createAt)"
        }
    }
}

public extension UIModel.ToDo {
    init(from domainModel: DomainModel.ToDo) {
        self.id = domainModel.id
        self.title = domainModel.todoTitle
        self.description = domainModel.todoDescription
        self.createAt = domainModel.createAt.createDateStamp()
        self.isCompleted = domainModel.isCompleted
    }

    public func toDomain() throws -> DomainModel.ToDo {
        DomainModel.ToDo(
            id: self.id,
            todoTitle: self.title,
            todoDescription: self.description,
            createAt: Current.makeDateFromStamp(string: self.createAt),
            isCompleted: self.isCompleted,
            userId: 1 // hardcode, has no user
        )
    }
}
