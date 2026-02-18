//
//  Mappers.swift
//  DataInterface
//
//  Created by Sergey Kemenov on 09.02.2026.
//


import Foundation
import DomainInterface
import Utilities

public struct ToDoDomainMapper {
    public static func toDomain(_ model: DTOModel.ToDo) throws -> DomainModel.ToDo {
        DomainModel.ToDo(
            id: model.id,
            todoTitle: model.todo,
            todoDescription: "",
            createAt: ToDoDomainMapper.fakeDate(),
            isCompleted: model.completed,
            userId: model.userId
        )
    }

    public static func toDTO(_ model: DomainModel.ToDo ) -> DTOModel.ToDo {
        DTOModel.ToDo(
            id: model.id,
            todo: model.todoTitle,
            completed: model.isCompleted,
            userId: model.userId
        )
    }

    private static func fakeDate() -> Date {
        Current.date().addMonth(Int.random(in: -3...0)).addDay(Int.random(in: -30...0))
    }
}
