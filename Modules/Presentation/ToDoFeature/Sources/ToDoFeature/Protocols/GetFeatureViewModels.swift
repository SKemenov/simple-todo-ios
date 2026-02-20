//
//  GetFeatureViewModels.swift
//  BlogPostFeature
//
//  Created by Sergey Kemenov on 08.02.2026.
//

import Foundation

public protocol GetFeatureViewModelsProtocol {
    func makeToDoListViewModel() -> ToDoListViewModel
    func makeToDoDetailViewModel() -> ToDoDetailViewModel
    func makeRootViewModel() -> RootViewModel
}
