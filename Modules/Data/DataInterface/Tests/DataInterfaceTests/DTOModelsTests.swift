//
//  DTOModelsTests.swift
//  DataInterface
//
//  Created by Sergey Kemenov on 19.02.2026.
//

import Testing
@testable import DataInterface
import Foundation

@Suite("DTO ToDo Codable")
struct DTOModelsTests {

    @Test("Full round-trip preserves all fields")
    func roundTrip() throws {
        let original = DTOModel.ToDo(
            id: 42,
            todo: "Buy milk",
            completed: true,
            userId: 7
        )

        let data = try JSONEncoder().encode(original)
        let sut = try JSONDecoder().decode(DTOModel.ToDo.self, from: data)

        // Can't compare sut and original, they don't conform to `Equatable`. Try to compare their properties
        #expect(sut.id == original.id)
        #expect(sut.todo == original.todo)
        #expect(sut.completed == original.completed)
        #expect(sut.id == 42)
        #expect(sut.todo == "Buy milk")
    }

    @Test("Minimal required fields decode correctly")
    func minimalDecoding() throws {
        let json = """
        {"id":123,"todo":"Test","completed":false,"userId":1}
        """.data(using: .utf8)!

        let sut = try JSONDecoder().decode(DTOModel.ToDo.self, from: json)
        #expect(sut.id == 123)
        #expect(sut.todo == "Test")
        #expect(sut.completed == false)
        #expect(sut.completed != true)
        #expect(sut.userId == 1)
    }
}
