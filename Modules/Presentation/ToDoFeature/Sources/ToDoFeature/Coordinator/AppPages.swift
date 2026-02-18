//
//  AppPages.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 10.02.2026.
//

import Foundation

// MARK: - Enum with AppCoordinator' pages
public enum AppPages: Hashable {
    case root
    case toDosList
    case createToDo
    case toDoDetail(model: UIModel.ToDo)
}
