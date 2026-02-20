//
//  UIModelTests.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 19.02.2026.
//

import Testing
@testable import ToDoFeature
import Foundation
import Utilities

@Suite("UIModel ToDo")
struct UIModelTests {
    private let date = Date().createDateStamp()

    @Test("Two equal todos are equal")
    func equality() {
        let id = UUID()
        let distantPast = Date.distantPast.createDateStamp()
        let sutA = UIModel.ToDo(id: id, title: "Task", description: "some", createAt: date, isCompleted: false)
        let sutB = UIModel.ToDo(id: id, title: "Task", description: "some", createAt: date, isCompleted: false)
        let sutC = UIModel.ToDo(id: id, title: "Task", description: "some", createAt: distantPast, isCompleted: false)

        #expect(sutA == sutB)
        #expect(sutA.id == sutB.id)
        #expect(sutA != sutC)
        #expect(sutA.id == sutC.id)
    }

    @Test("Different ids are not equal")
    func inequalityById() {
        let sutA = UIModel.ToDo(id: UUID(), title: "A", description: "some", createAt: date, isCompleted: false)
        let sutB = UIModel.ToDo(id: UUID(), title: "A", description: "some", createAt: date, isCompleted: false)
        #expect(sutA != sutB)
    }

    @Test("Hashable consistency – same values same hash")
    func hashable() {
        let id = UUID()
        let sutA = UIModel.ToDo(id: id, title: "Test", description: "some", createAt: date, isCompleted: false)
        let sutB = UIModel.ToDo(id: id, title: "Test", description: "some", createAt: date, isCompleted: false)

        var hasherA = Hasher(), hasherB = Hasher()
        sutA.hash(into: &hasherA)
        sutB.hash(into: &hasherB)

        #expect(hasherA.finalize() == hasherB.finalize())
    }

    @Test("Identifiable — id is the identity")
    func identifiable() {
        let id = UUID()
        let sut = UIModel.ToDo(id: id, title: "Test", description: "", createAt: "", isCompleted: false)

        #expect(sut.id == id)
    }
}
