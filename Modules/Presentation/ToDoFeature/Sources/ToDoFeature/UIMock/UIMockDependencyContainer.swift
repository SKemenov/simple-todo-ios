//
//  UIMockDependencyContainer.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 19.02.2026.
//

#if DEBUG
import Foundation
import Combine
import DomainInterface
import ToDoUseCases

final class UIMockDependencyContainer: ObservableObject, GetFeatureViewModelsProtocol {
    init() { }
    lazy var toDoRepository: ToDoRepositoryProtocol = {
        UIMockToDoRepository()
    }()

    lazy var createToDoUseCase: CreateToDoUseCaseProtocol = {
        CreateToDoUseCase(repository: toDoRepository)
    }()

    lazy var updateToDoUseCase: UpdateToDoUseCaseProtocol = {
        UpdateToDoUseCase(repository: toDoRepository)
    }()

    lazy var deleteToDoUseCase: DeleteToDoUseCaseProtocol = {
        DeleteToDoUseCase(repository: toDoRepository)
    }()

    lazy var completeToDoUseCase: CompleteToDoUseCaseProtocol = {
        CompleteToDoUseCase(repository: toDoRepository)
    }()

    lazy var getAllToDosUseCase: GetAllToDosUseCaseProtocol = {
        GetAllToDosUseCase(repository: toDoRepository)
    }()

    lazy var getClearCacheToDoUseCase: ClearCacheToDoUseCaseProtocol = {
        ClearCacheToDoUseCase(repository: toDoRepository)
    }()

    // MARK: - GetFeatureViewModelsProtocol
    func makeToDoListViewModel() -> ToDoListViewModel {
        .init(
            getAllToDosUseCase: getAllToDosUseCase,
            deleteToDoUseCase: deleteToDoUseCase,
            completeToDoUseCase: completeToDoUseCase
        )
    }

    func makeToDoDetailViewModel() -> ToDoDetailViewModel {
        .init(
            createUseCase: createToDoUseCase,
            updateUseCase: updateToDoUseCase
        )
    }

    func makeRootViewModel() -> RootViewModel {
        .init(
            getAllToDosUseCase: getAllToDosUseCase,
            clearCacheToDoUseCase: getClearCacheToDoUseCase,
        )
    }
}
#endif
