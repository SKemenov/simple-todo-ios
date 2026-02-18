//
//  DTOModels.swift
//  DataInterface
//
//  Created by Sergey Kemenov on 09.02.2026.
//

import Foundation

public enum DTOModel {
}

extension DTOModel {
    public struct ToDo: Codable, CustomStringConvertible {
        public var id: Int
        public var todo: String
        public var completed: Bool
        public var userId: Int

        public init(id: Int, todo: String, completed: Bool, userId: Int) {
            self.id = id
            self.todo = todo
            self.completed = completed
            self.userId = userId
        }

        public var description: String {
            "DTOModel.ToDo(id: \(id), todo: \(todo), completed: \(completed), userId: \(userId))"
        }
    }

    public struct ToDos: Codable {
        public var todos: [ToDo]
        public var total: Int
        public var skip: Int
        public var limit: Int

        public init(todos: [ToDo], total: Int, skip: Int, limit: Int) {
            self.todos = todos
            self.total = total
            self.skip = skip
            self.limit = limit
        }
    }

    public struct UpdateToDo: Codable {
        public var todo: String?
        public var completed: Bool?

        public init(todo: String? = nil, completed: Bool? = nil) {
            self.todo = todo
            self.completed = completed
        }
    }
}
