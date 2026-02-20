//
//  DomainModelTests.swift
//  DomainInterface
//
//  Created by Sergey Kemenov on 19.02.2026.
//

import Testing
@testable import DomainInterface
import Foundation

@Suite("Domain ToDo models")
struct DomainModelTests {

    @Test("Two equal todos are equal")
    func equality() {
        let date = Date()
        let id = UUID()
        let sutA = DomainModel.ToDo(id: id, todoTitle: "Task", createAt: date)
        let sutB = DomainModel.ToDo(id: id, todoTitle: "Task", createAt: date)
        let sutC = DomainModel.ToDo(id: id, todoTitle: "Task", createAt: .distantPast)

        #expect(sutA == sutB)
        #expect(sutA.id == sutB.id)
        #expect(sutA != sutC)
        #expect(sutA.id == sutC.id)
    }

    @Test("Different ids are not equal")
    func inequalityById() {
        let sutA = DomainModel.ToDo(todoTitle: "A")
        let sutB = DomainModel.ToDo(todoTitle: "A")
        #expect(sutA != sutB)
    }

    @Test("Hashable consistency – same values same hash")
    func hashable() {
        let id = UUID()
        let sutA = DomainModel.ToDo(id: id, todoTitle: "Test")
        let sutB = DomainModel.ToDo(id: id, todoTitle: "Test")

        /// Sometimes `Hasher` can be failed, because of it's algorithm, see the doc quote here:
        ///
        ///   The hash algorithm implemented by `Hasher` may itself change between any two
        ///   versions of the standard library.
        var hasherA = Hasher(), hasherB = Hasher()
        sutA.hash(into: &hasherA)
        sutB.hash(into: &hasherB)

        #expect(hasherA.finalize() == hasherB.finalize())
    }


    @Test("Identifiable — id is the identity")
    func identifiable() {
        let id = UUID()
        let sut = DomainModel.ToDo(id: id, todoTitle: "Test")

        #expect(sut.id == id)
    }
}
