//
//  MockFileLoader.swift
//  LocalStores
//
//  Created by Sergey Kemenov on 18.02.2026.
//

#if DEBUG
import Foundation
import DomainInterface
import DataInterface
import Logging
import Utilities

struct MockFileLoader: Sendable {
    static func load(_ filename: String, _ fileExt: String = "json") -> [DomainModel.ToDo] {
        let data: Data
        let fullName = "\(filename).\(fileExt)"

        guard let file = Bundle.module.url(forResource: filename, withExtension: fileExt) else {
            let message = "\(String.logHeader()) Couldn't find \(filename) in module bundle (in Resources folder)"
            Logger.storage.critical("\(message)")
            fatalError(message)
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            let message = "\(String.logHeader()) Couldn't load \(fullName) from module bundle:\n\(error)"
            Logger.storage.critical("\(message)")
            fatalError(message)
        }

        do {
            let result = try Current.decoder.decode(DTOModel.ToDos.self, from: data)
            Logger.storage.info("\(String.logHeader()) Parsed \(fullName) and loaded \(DTOModel.ToDos.self)")
            return try result.todos.map { try ToDoDomainMapper.toDomain($0) }
        } catch {
            let message = "\(String.logHeader()) Couldn't parse \(fullName) as \(DTOModel.ToDos.self):\n\(error)"
            Logger.storage.critical("\(message)")
            fatalError(message)
        }
    }
}
#endif
