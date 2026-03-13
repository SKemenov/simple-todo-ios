//
//  UIMockAppContainer.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 19.02.2026.
//

#if DEBUG
import Foundation
import DomainInterface
import ToDoUseCases

final class UIMockAppDIContainer: ObservableObject, ToDoFeatureViewModelsProtocol {
    private let errorManager: ErrorManager
    private let networkState: NetworkState

    init() {
        self.errorManager = ErrorManager()
        self.networkState = NetworkState()
    }
    private lazy var toDoRepository: ToDoRepositoryProtocol = {
        UIMockToDoRepository()
    }()

    private lazy var createToDoUseCase: CreateToDoUseCaseProtocol = {
        CreateToDoUseCase(repository: toDoRepository)
    }()

    private lazy var updateToDoUseCase: UpdateToDoUseCaseProtocol = {
        UpdateToDoUseCase(repository: toDoRepository)
    }()

    private lazy var deleteToDoUseCase: DeleteToDoUseCaseProtocol = {
        DeleteToDoUseCase(repository: toDoRepository)
    }()

    private lazy var completeToDoUseCase: CompleteToDoUseCaseProtocol = {
        CompleteToDoUseCase(repository: toDoRepository)
    }()

    private lazy var getAllToDosUseCase: GetAllToDosUseCaseProtocol = {
        GetAllToDosUseCase(repository: toDoRepository)
    }()

    private lazy var clearCacheToDoUseCase: ClearCacheToDoUseCaseProtocol = {
        ClearCacheToDoUseCase(repository: toDoRepository)
    }()

    // MARK: - GetFeatureViewModelsProtocol
    func makeToDoListViewModel() -> ToDoListViewModel {
        .init(
            getAllToDosUseCase: getAllToDosUseCase,
            deleteToDoUseCase: deleteToDoUseCase,
            completeToDoUseCase: completeToDoUseCase,
            errorManager: errorManager,
            networkState: networkState
        )
    }

    func makeToDoDetailViewModel(toDo: UIModel.ToDo?) -> ToDoDetailViewModel {
        .init(
            createUseCase: createToDoUseCase,
            updateUseCase: updateToDoUseCase,
            toDo: toDo,
            errorManager: errorManager,
            networkState: networkState
        )
    }

    func makeRootViewModel() -> RootViewModel {
        .init(
            getAllToDosUseCase: getAllToDosUseCase,
            clearCacheToDoUseCase: clearCacheToDoUseCase,
            errorManager: errorManager,
            networkState: networkState
        )
    }
}
#endif
