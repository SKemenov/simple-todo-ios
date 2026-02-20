//
//  CoreDataToDoLocalDataSourceTests.swift
//  LocalStores
//
//  Created by Sergey Kemenov on 19.02.2026.
//

import Testing
@testable import LocalStores
import CoreData
import DomainInterface

@Suite("CoreDataToDoLocalDataSource Tests")
struct CoreDataToDoLocalDataSourceTests {

    // Should run these tests one by one, as a serial queue
    let persistence = PersistenceController.inMemory
    lazy var sut = CoreDataToDoLocalDataSource(persistence: persistence)
    
    private func countOfTodos() async throws -> Int {
        try await persistence.performBackground { context in
            let request = CDToDo.fetchRequest()
            return try context.count(for: request)
        }
    }
    
    private mutating func fetchAllDomainTodos() async throws -> [DomainModel.ToDo] {
        try await sut.fetchAllToDos()
    }
    
    @Test("saveToDo creates new record when not exists")
    mutating func saveNew() async throws {
        let initialCount = try await countOfTodos()
        let id = UUID()
        let newTodo = DomainModel.ToDo(
            id: id,
            todoTitle: "Test task",
            todoDescription: "Details",
            createAt: Date(),
            isCompleted: false,
            userId: 42
        )
        
        try await sut.saveToDo(newTodo)
        
        let afterCount = try await countOfTodos()
        #expect(afterCount == initialCount + 1)
        
        let all = try await fetchAllDomainTodos()
        #expect(all.contains { $0.id == id })
        #expect(all.contains { $0.todoTitle == "Test task" })
        #expect(all.first { $0.todoTitle == "Test task" }?.id == id)
        #expect(all.first { $0.id == id }?.todoTitle == "Test task")
    }
    
    @Test("saveToDo updates existing record")
    mutating func saveUpdatesExisting() async throws {
        // First save
        try await sut.clearCache()
        let id = UUID()
        let todo = DomainModel.ToDo(id: id, todoTitle: "Original", isCompleted: false, userId: 1)
        try await sut.saveToDo(todo)
        
        // Update
        var updated = todo
        updated.todoTitle = "Modified title"
        updated.isCompleted = true
        
        try await sut.saveToDo(updated)
        
        let all = try await fetchAllDomainTodos()
        let found = all.first { $0.id == id }
        #expect(found?.todoTitle == "Modified title")
        #expect(found?.isCompleted == true)
        #expect(all.count == 1) // still one record
    }

    @Test("clearCache removes all records")
    mutating func clearCache() async throws {
        try await sut.clearCache()
        // Pre-fill
        for i in 1...5 {
            let todo = DomainModel.ToDo(todoTitle: "Item \(i)")
            try await sut.saveToDo(todo)
        }

        #expect(try await countOfTodos() == 5)

        try await sut.clearCache()
        
        #expect(try await countOfTodos() == 0)
        #expect((try await fetchAllDomainTodos()).isEmpty)
    }
    
    @Test("syncAllTodos inserts new items only")
    mutating func syncNewItems() async throws {
        let initialCount = try await countOfTodos()
        
        let dtos = (1...10).map { i in
            DomainModel.ToDo(todoTitle: "Sync \(i)")
        }
        
        try await sut.syncAllTodos(dtos)
        
        #expect(try await countOfTodos() == initialCount + 10)
    }
}
