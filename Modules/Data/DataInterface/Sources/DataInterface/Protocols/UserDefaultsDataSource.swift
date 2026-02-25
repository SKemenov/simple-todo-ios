//
//  UserDefaultsDataSourceProtocol.swift
//  DataInterface
//
//  Created by Sergey Kemenov on 17.02.2026.
//

import Foundation

public protocol UserDefaultsDataSourceProtocol {
    var isCoreDataSynced: Bool { get set }
    var isAppAlreadyHasFirstLaunch: Bool { get set }
}
