//
//  ToDoMapperTests.swift
//  DataInterface
//
//  Created by Sergey Kemenov on 19.02.2026.
//

import Testing
@testable import DataInterface
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
}
