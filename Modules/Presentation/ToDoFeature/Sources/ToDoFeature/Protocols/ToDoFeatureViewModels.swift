//
//  ToDoFeatureViewModelsProtocol.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 08.02.2026.
//

import Foundation

public protocol ToDoFeatureViewModelsProtocol {
    func makeToDoListViewModel() -> ToDoListViewModel
    func makeToDoDetailViewModel(toDo: UIModel.ToDo?) -> ToDoDetailViewModel
    func makeRootViewModel() -> RootViewModel
}

public extension ToDoFeatureViewModelsProtocol {
    func makeToDoDetailViewModel() -> ToDoDetailViewModel {
        makeToDoDetailViewModel(toDo: nil)
    }
}
