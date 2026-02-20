import Foundation
import Combine
import DataInterface
import DomainInterface
import LocalStores
import Networking
import Repositories
import ToDoUseCases
import ToDoFeature
import Logging
import Utilities

final class DependencyContainer {
    init() {
        Logger.core.info("\(String.logHeader()) Container started")
    }

    deinit {
        Logger.core.info("\(String.logHeader()) Container deinited")
    }

    // MARK: - Public properties
    public lazy var persistenceController: PersistenceController = {
        Logger.core.info("\(String.logHeader()) Requesting persistenceController")
        return PersistenceController.shared
    }()

    public lazy var userDefaultsDataSource: UserDefaultsDataSourceProtocol = {
        Logger.core.info("\(String.logHeader()) Requesting userDefaultsDataSource")
        return UserDefaultsDataSource()
    }()

    // MARK: - Private properties
    public lazy var toDoRemoteDataSource: ToDoRemoteDataSourceProtocol = {
        ToDoRemoteDataSource()
    }()

    public lazy var toDoLocalDataSource: ToDoLocalDataSourceProtocol = {
        CoreDataToDoLocalDataSource(persistence: persistenceController)
    }()

    public lazy var toDoRepository: ToDoRepositoryProtocol = {
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

    private lazy var getClearCacheToDoUseCase: ClearCacheToDoUseCaseProtocol = {
        ClearCacheToDoUseCase(repository: toDoRepository)
    }()
}

// MARK: - GetFeatureViewModelsProtocol
extension DependencyContainer: GetFeatureViewModelsProtocol {
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
