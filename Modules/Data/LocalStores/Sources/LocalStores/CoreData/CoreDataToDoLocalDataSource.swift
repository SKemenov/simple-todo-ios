//
//  CoreDataToDoLocalDataSource.swift
//  ToDoList
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
        Logger.storage.info("\(Current.logHeader()) Started")
    }

    deinit {
        Logger.storage.info("\(Current.logHeader()) Deinited")
    }

    public func fetchAllToDos() async throws -> [DomainModel.ToDo] {
        let context = persistence.container.viewContext // main thread

        return try await context.perform {
            let request = CDToDo.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "createAt", ascending: false)]

            let results = try context.fetch(request)
            Logger.storage.info("\(Current.logHeader()) has fetched \(results.count) records")

            return results.map { $0.toDomain() }
        }
    }

    public func saveToDo(_ dto: DomainModel.ToDo) async throws {
        let context = persistence.container.viewContext // or newBackgroundContext() — see note below

        try await context.perform {
            let request = CDToDo.fetchRequest()
            request.predicate = NSPredicate(format: "id == %lld", dto.id)
            let existing = try context.fetch(request).first

            let model: CDToDo
            if let existing {
                model = existing
            } else {
                model = CDToDo(context: context)
                model.id = Int64(dto.id)
            }

            model.update(from: dto)
            try context.save()
            Logger.storage.info("\(Current.logHeader()) Saved todo with id [\(model.id)] in CoreData")
        }
    }

    public func deleteToDo(id: Int) async throws {
        let context = persistence.container.viewContext

        try await context.perform {
            let request = CDToDo.fetchRequest()
            request.predicate = NSPredicate(format: "id == %lld", Int64(id))

            if let model = try context.fetch(request).first {
                context.delete(model)
                try context.saveIfNeeded()
                Logger.storage.info("\(Current.logHeader()) Deleted todo with id [\(model.id)] in CoreData")
            } else {
                Logger.storage.info("\(Current.logHeader()) Record not found, nothing to delete")
            }
        }
    }

    public func clearCache() async throws {
        let context = persistence.newBackgroundContext()
        try await context.perform {
            let deleteRequest: NSFetchRequest<NSFetchRequestResult> = CDToDo.fetchRequest()
            let batchDelete = NSBatchDeleteRequest(fetchRequest: deleteRequest)
            batchDelete.resultType = .resultTypeCount  // we can log how many deleted

            let deleteResult = try context.execute(batchDelete) as? NSBatchDeleteResult
            let deletedCount = deleteResult?.result as? Int ?? 0
            try context.saveIfNeeded()
            Logger.storage.info("\(Current.logHeader()) Deleted \(deletedCount) todos in CoreData")
        }
    }

    public func syncAllTodos(_ dtos: [DomainModel.ToDo]) async throws {
        let context = persistence.newBackgroundContext()

        try await context.perform {
            for dto in dtos {
                let model = CDToDo(context: context)
                model.id = Int64(dto.id)
                model.update(from: dto)
            }
            try context.saveIfNeeded()
            Logger.storage.info("\(Current.logHeader()) Synced \(dtos.count) todos in CoreData")
        }
    }
}

// MARK: - Helpers
extension CDToDo {
    func toDomain() -> DomainModel.ToDo {
        DomainModel.ToDo(
            id: Int(self.id),
            todoTitle: self.todoTitle ?? "",
            todoDescription: self.todoDescription ?? "",
            createAt: self.createAt ?? Current.date().startOfLocalDay(),
            isCompleted: self.isCompleted,
            userId: Int(self.userId)
        )
    }

    func update(from dto: DomainModel.ToDo) {
        self.todoTitle = dto.todoTitle
        self.todoDescription = dto.todoDescription
        self.createAt = dto.createAt
        self.isCompleted = dto.isCompleted
        self.userId = Int64(dto.userId)
    }
}

extension NSManagedObjectContext {
    func saveIfNeeded() throws {
        if hasChanges {
            try save()
        }
    }
}
