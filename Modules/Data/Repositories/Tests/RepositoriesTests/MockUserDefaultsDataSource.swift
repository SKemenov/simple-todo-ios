//
//  MockUserDefaultsDataSource.swift
//  Repositories
//
//  Created by Sergey Kemenov on 25.02.2026.
//

import Testing
@testable import Repositories
import DataInterface

final class MockUserDefaultsDataSource: UserDefaultsDataSourceProtocol {
    var isAppAlreadyHasFirstLaunch: Bool
    var isCoreDataSynced: Bool

    init(isCoreDataSynced: Bool = false, isAppAlreadyHasFirstLaunch: Bool = false) {
        self.isCoreDataSynced = isCoreDataSynced
        self.isAppAlreadyHasFirstLaunch = isAppAlreadyHasFirstLaunch
    }
}
