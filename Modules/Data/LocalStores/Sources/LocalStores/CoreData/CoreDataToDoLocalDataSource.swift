//
//  CoreDataToDoLocalDataSource.swift
//  LocalStores
//
//  Created by Sergey Kemenov on 17.02.2026.
//

import Foundation
import CoreData
import Logging
import Utilities
import DomainInterface
import DataInterface

public actor CoreDataToDoLocalDataSource: ToDoLocalDataSourceProtocol {

    private let persistence: PersistenceController

    public init(persistence: PersistenceController = .shared) {
        self.persistence = persistence
        Logger.storage.info("\(String.logHeader()) Started")
    }

    deinit {
        Logger.storage.info("\(String.logHeader()) Deinited")
    }

    public func fetchAllToDos() async throws -> [DomainModel.ToDo] {
        try await persistence.performBackground { context in
            let request = CDToDo.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "createAt", ascending: false)]

            let results = try context.fetch(request)
            Logger.storage.info("\(String.logHeader()) has fetched \(results.count) records")
            return results.map { $0.toDomain() }
        }
    }

    public func getToDo(id: UUID) async throws -> DomainModel.ToDo? {
        try await persistence.performBackground { context in
            let request = CDToDo.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            guard let cd = try context.fetch(request).first else { return nil }
            return cd.toDomain()
        }
    }

    public func saveToDo(_ model: DomainModel.ToDo) async throws {
        try await persistence.performBackground { context in
            let request = CDToDo.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", model.id as CVarArg)
            let existing = try context.fetch(request).first

            let new: CDToDo
            if let existing {
                new = existing
                Logger.storage.info("\(String.logHeader()) Updating existing todo [\(model.id)]")
            } else {
                new = CDToDo(context: context)
                new.id = model.id
                Logger.storage.info("\(String.logHeader()) Creating new todo [\(model.id)]")
            }

            new.update(from: model)
            try context.saveIfNeeded()
            Logger.storage.info("\(String.logHeader()) Saved todo [\(model.id)] in CoreData")
        }
    }

    public func deleteToDo(id: UUID) async throws {
        try await persistence.performBackground { context in
            let request = CDToDo.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            if let model = try context.fetch(request).first {
                context.delete(model)
                try context.saveIfNeeded()
                Logger.storage.info("\(String.logHeader()) Deleted todo [\(id)] in CoreData")
            } else {
                Logger.storage.info("\(String.logHeader()) Record not found, nothing to delete")
            }
        }
    }

    public func clearCache() async throws {
        try await persistence.performBackground { context in
            let deleteRequest: NSFetchRequest<NSFetchRequestResult> = CDToDo.fetchRequest()
            let batchDelete = NSBatchDeleteRequest(fetchRequest: deleteRequest)
            batchDelete.resultType = .resultTypeCount

            let deleteResult = try context.execute(batchDelete) as? NSBatchDeleteResult
            let deletedCount = deleteResult?.result as? Int ?? 0
            try context.saveIfNeeded()
            Logger.storage.info("\(String.logHeader()) Deleted \(deletedCount) todos in CoreData")
        }
    }

    public func syncAllTodos(_ models: [DomainModel.ToDo]) async throws {
        guard !models.isEmpty else { return }
        try await persistence.performBackground { context in
            for dto in models {
                let model = CDToDo(context: context)
                model.update(from: dto)
            }
            try context.saveIfNeeded()
            Logger.storage.info("\(String.logHeader()) Synced \(models.count) todos in CoreData")
        }
    }
}

// MARK: - Helpers
extension CDToDo {
    func toDomain() -> DomainModel.ToDo {
        DomainModel.ToDo(
            id: self.id ?? UUID(),
            dtoId: self.dtoId == -1 ? nil : Int(self.dtoId),
            todoTitle: self.todoTitle ?? "",
            todoDescription: self.todoDescription ?? "",
            createAt: self.createAt ?? Current.date().startOfLocalDay(),
            isCompleted: self.isCompleted,
            userId: Int(self.userId)
        )
    }

    func update(from domain: DomainModel.ToDo) {
        self.id = domain.id
        self.dtoId = Int64(domain.dtoId ?? -1)
        self.todoTitle = domain.todoTitle
        self.todoDescription = domain.todoDescription
        self.createAt = domain.createAt
        self.isCompleted = domain.isCompleted
        self.userId = Int64(domain.userId)
    }
}

extension NSManagedObjectContext {
    func saveIfNeeded() throws {
        if hasChanges {
            try save()
        }
    }
}
