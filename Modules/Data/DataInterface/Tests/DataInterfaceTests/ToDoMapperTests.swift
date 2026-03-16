//
//  ToDoMapperTests.swift
//  DataInterface
//
//  Created by Sergey Kemenov on 19.02.2026.
//

import Testing
@testable import DataInterface
@testable import DomainInterface
import Foundation

@Suite("ToDo Mapper")
struct ToDoMapperTests {

    @Test("DTO → Domain preserves core data")
    func toDomain() throws {
        let dto = DTOModel.ToDo(id: 100, todo: "  Trim me  ", completed: true, userId: 3)

        let sut = try ToDoDomainMapper.toDomain(dto)

        #expect(sut.dtoId == 100)
        #expect(sut.todoTitle == "Trim me") // trimmed
        #expect(sut.todoDescription.isEmpty) // default value
        #expect(sut.isCompleted == true)
        #expect(sut.userId == 3)
    }

    @Test("Domain → DTO preserves core data")
    func toDTO() {
        let domain = DomainModel.ToDo(
            dtoId: 42,
            todoTitle: "Buy milk",
            todoDescription: "2% fat",
            isCompleted: false,
            userId: 7
        )

        let sut = ToDoDomainMapper.toDTO(domain)

        #expect(sut.id == 42)
        #expect(sut.todo == "Buy milk")
        #expect(sut.completed == false)
        #expect(sut.userId == 7)
    }

    @Test("Domain → DTO uses fallback id when dtoId is nil")
    func toDTONilId() {
        let domain = DomainModel.ToDo(todoTitle: "New task")

        let sut = ToDoDomainMapper.toDTO(domain)

        #expect(sut.id == 1)
    }
}
