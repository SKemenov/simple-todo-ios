//
//  ToDoLocalDataSource.swift
//  LocalStores
//
//  Created by Sergey Kemenov on 07.02.2026.
//

import Foundation
import DataInterface
import Logging

public final class UserDefaultsDataSource: UserDefaultsDataSourceProtocol {
    private let userDefaults = UserDefaults.standard
    private enum Keys {
        static let coreDataKey = "is_core_data_synced"
        static let launchKey = "is_app_already_has_first_launch"
    }

    public init() {
        Logger.storage.info("\(String.logHeader()) Started")
    }

    deinit {
        Logger.storage.info("\(String.logHeader()) Deinited")
    }

    public var isCoreDataSynced: Bool {
        get { userDefaults.bool(forKey: Keys.coreDataKey) }
        set { userDefaults.set(newValue, forKey: Keys.coreDataKey) }
    }

    public var isAppAlreadyHasFirstLaunch: Bool {
        get { userDefaults.bool(forKey: Keys.launchKey) }
        set { userDefaults.set(newValue, forKey: Keys.launchKey) }
    }
}
