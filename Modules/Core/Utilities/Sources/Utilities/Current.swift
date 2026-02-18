//
//  Current.swift
//  Utilities
//
//  Created by Sergey Kemenov on 07.02.2026.
//

import Foundation
import Logging

// Based on this article: https://www.pointfree.co/blog/posts/21-how-to-control-the-world

// swiftlint:disable identifier_name
#if DEBUG
public var Current = World()
#else
public let Current = World()
#endif
// swiftlint:enable identifier_name

public struct World {
    public var calendar = Calendar.autoupdatingCurrent
    /// Current date at UTC timezone
    public var date = { Date() }
    public var timeZoneInterval: Double { Double(TimeZone.autoupdatingCurrent.secondsFromGMT()) }
    public var decoder = JSONDecoder.createDecoder()
    public var encoder = JSONEncoder.createEncoder()
    public let formatter = DateFormatter.createFormatter()

    init() {
        Logger.core.info("\(#fileID) Started")
    }

    public func logHeader(fileID: StaticString = #fileID, function: StaticString = #function) -> String {
        /// Module name/File name without ext
        let fileName = String(describing: fileID).components(separatedBy: ".").first ?? String(describing: fileID)
        let functionName = String(describing: function).components(separatedBy: "()").first
        ?? String(describing: function).components(separatedBy: "(_:").first
        ?? String(describing: function)
        return "[\(fileName).\(functionName)]"
    }

    public func makeDateFromStamp(string: String) -> Date {
        if let date = formatter.date(from: string) {
            return date.fromLocalDate()
        } else {
            return date()
        }
    }
}

public let dateFormatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    return formatter
}()

public extension String {
    var trimSpaces: Self {
        self.trimmingCharacters(in: .whitespaces)
    }
}
