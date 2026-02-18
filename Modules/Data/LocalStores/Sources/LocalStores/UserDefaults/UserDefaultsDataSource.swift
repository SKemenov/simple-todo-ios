//
//  ToDoLocalDataSource.swift
//  LocalStores
//
//  Created by Sergey Kemenov on 07.02.2026.
//

import Foundation
import DataInterface
import Utilities
import Logging

public final class UserDefaultsDataSource: UserDefaultsDataSourceProtocol {
    private let userDefaults = UserDefaults.standard
    private let coreDataKey = "is_core_data_synced"

    public init() {
        Logger.storage.info("\(Current.logHeader()) Started")
    }

    deinit {
        Logger.storage.info("\(Current.logHeader()) Deinited")
    }

    public var isCoreDataSynced: Bool {
        get { userDefaults.bool(forKey: coreDataKey) }
        set { userDefaults.set(newValue, forKey: coreDataKey) }
    }
}
