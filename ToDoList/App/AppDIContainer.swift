import Foundation
import DataInterface
import DomainInterface
import LocalStores
import Networking
import Repositories
import ToDoUseCases
import ToDoFeature
import Logging
import Utilities

final class AppDIContainer {
    private let errorManager: ErrorManager
    private let networkState: NetworkState

    init(errorManager: ErrorManager, networkState: NetworkState) {
        self.errorManager = errorManager
        self.networkState = networkState
        Logger.core.info("\(String.logHeader()) Container started")
    }

    deinit {
        Logger.core.info("\(String.logHeader()) Container deinited")
    }

    // MARK: - Data layer
    public lazy var persistenceController: PersistenceController = {
        Logger.core.info("\(String.logHeader()) Requesting persistenceController")
        return PersistenceController.shared
    }()

    private lazy var userDefaultsDataSource: UserDefaultsDataSourceProtocol = {
        Logger.core.info("\(String.logHeader()) Requesting userDefaultsDataSource")
        return UserDefaultsDataSource()
    }()

    private lazy var toDoRemoteDataSource: ToDoRemoteDataSourceProtocol = {
        ToDoRemoteDataSource()
    }()

    private lazy var toDoLocalDataSource: ToDoLocalDataSourceProtocol = {
        CoreDataToDoLocalDataSource(persistence: persistenceController)
    }()

    private lazy var toDoRepository: ToDoRepositoryProtocol = {
        ToDoRepository(
            remoteDataSource: toDoRemoteDataSource,
            localDataSource: toDoLocalDataSource,
            userDefaults: userDefaultsDataSource
        )
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
}

// MARK: - GetFeatureViewModelsProtocol
extension AppDIContainer: ToDoFeatureViewModelsProtocol {
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
