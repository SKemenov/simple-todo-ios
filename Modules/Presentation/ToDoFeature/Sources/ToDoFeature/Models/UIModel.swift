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
    public struct AppError: Identifiable {
        public let id = UUID()
        public let kind: Kind
        public let message: String
        public let retry: (@Sendable () async -> Void)?

        public init(kind: Kind = .general, message: String, retry: (@Sendable () async -> Void)? = nil) {
            self.kind = kind
            self.message = message
            self.retry = retry
        }

        public enum Kind {
            case network
            case storage
            case general

            public init(from error: Error) {
                switch error {
                case is URLError:
                    self = .network
                case let nsError as NSError where nsError.domain == NSCocoaErrorDomain:
                    self = .storage
                default:
                    self = .general
                }
            }
        }
    }
}

extension UIModel {
    public struct ToDo: Identifiable, Equatable, Hashable {
        public var id: UUID
        public var title: String
        public var description: String
        public var createAt: String
        public var isCompleted: Bool

        public init(id: UUID, title: String, description: String, createAt: String, isCompleted: Bool) {
            self.id = id
            self.title = title
            self.description = description
            self.createAt = createAt
            self.isCompleted = isCompleted
        }

        public var searchable: String {
            "\(title) \(description) \(createAt)"
        }

        public var formattedCreateAt: String {
            Current.date().createDateStamp()
        }

        public var exportAsString: String {
            let newLine = "\n"
            let complete = String(localized: LocalizedStringResource.todoStatusCompleted)
            let incomplete = String(localized: LocalizedStringResource.todoStatusInProgress)

            let title = String(localized: LocalizedStringResource.todoTitle(self.title))
            let createAt = String(localized: LocalizedStringResource.todoCreated(self.createAt))

            let status = String(localized: LocalizedStringResource.todoStatus(self.isCompleted ? complete : incomplete))
            let description = self.description.isEmpty
            ? String()
            : newLine + String(localized: LocalizedStringResource.todoDetail(self.description))

            return title + newLine + status + newLine + createAt + description
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

    func toDomain() throws -> DomainModel.ToDo {
        DomainModel.ToDo(
            id: self.id,
            todoTitle: self.title,
            todoDescription: self.description,
            createAt: self.createAt.makeDateFromStamp(),
            isCompleted: self.isCompleted
        )
    }
}
