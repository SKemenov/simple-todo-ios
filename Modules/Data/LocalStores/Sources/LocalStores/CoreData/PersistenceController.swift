//
//  PersistenceController.swift
//  ToDoList
//
//  Created by Sergey Kemenov on 17.02.2026.
//

import Foundation
import CoreData
import Utilities
import Logging


public struct PersistenceController {
    public static let shared = PersistenceController()
    public let container: NSPersistentContainer

    // For test & previews
    @MainActor
    public static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let todos = MockFileLoader.load("todos")

        for todo in todos {
            let model = CDToDo(context: viewContext)
            model.update(from: todo)
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            let message = "\(Current.logHeader()) Unresolved error \(nsError), \(nsError.userInfo)"
            Logger.storage.critical("\(message)")
        }
        return result
    }()


    private init(inMemory: Bool = false) {
        let modelName = "CDModel"

        guard let modelURL = Bundle.module.url(forResource: modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            let message = "\(Current.logHeader()) Failed to load CoreData [\(modelName)] model"
            Logger.storage.critical("\(message)")
            fatalError(message)
        }

        container = NSPersistentContainer(name: modelName, managedObjectModel: model)

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error {
                let message = "\(Current.logHeader()) CoreData store load failed: \(error)"
                Logger.storage.critical("\(message)")
                fatalError(message)
            }
            Logger.storage.info("\(Current.logHeader()) Core Data loaded: \(description)")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    nonisolated
    public func newBackgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        context.automaticallyMergesChangesFromParent = true
        return context
    }
}
