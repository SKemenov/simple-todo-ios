//
//  Logging.swift
//  Logging
//
//  Created by Sergey Kemenov on 07.02.2026.
//

@_exported import OSLog

public extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "ToDoList"

    static let core = Logger(subsystem: Logger.subsystem, category: "core")
    static let network = Logger(subsystem: Logger.subsystem, category: "data.network")
    static let storage = Logger(subsystem: Logger.subsystem, category: "data.storage")
    static let repos = Logger(subsystem: Logger.subsystem, category: "data.repos")
    static let userFlow = Logger(subsystem: subsystem, category: "UI.userFlow")
}
