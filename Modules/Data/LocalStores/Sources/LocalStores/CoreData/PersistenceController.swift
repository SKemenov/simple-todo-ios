//
//  PersistenceController.swift
//  LocalStores
//
//  Created by Sergey Kemenov on 17.02.2026.
//

import Foundation
import CoreData
import Logging

public struct PersistenceController {
    private let container: NSPersistentContainer
    public static let shared = PersistenceController()

    #if DEBUG
    // For tests
    public static let inMemory = PersistenceController(inMemory: true)
    #endif

    private init(inMemory: Bool = false) {
        let modelName = "CDModel"

        guard let modelURL = Bundle.module.url(forResource: modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            let message = "\(String.logHeader()) Failed to load CoreData [\(modelName)] model"
            Logger.storage.critical("\(message)")
            fatalError(message)
        }

        container = NSPersistentContainer(name: modelName, managedObjectModel: model)

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error {
                let message = "\(String.logHeader()) CoreData store load failed: \(error)"
                Logger.storage.critical("\(message)")
                fatalError(message)
            }
            Logger.storage.info("\(String.logHeader()) Core Data loaded: \(description)")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    public func newBackgroundContext() async -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        context.automaticallyMergesChangesFromParent = true
        return context
    }

    public func performBackground<T>(
        _ action: @Sendable @escaping (NSManagedObjectContext) throws -> T
    ) async rethrows -> T {
        let context = await newBackgroundContext()
        return try await context.perform {
            try action(context)
        }
    }
}
