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

public struct World: @unchecked Sendable {
    public nonisolated var calendar = Calendar.autoupdatingCurrent
    /// Current date at UTC timezone
    public nonisolated var date: @Sendable () -> Date = { Date() }
    public nonisolated var timeZoneInterval: Double { Double(TimeZone.autoupdatingCurrent.secondsFromGMT()) }
    public nonisolated var decoder: JSONDecoder { JSONDecoder.createDecoder() }
    public nonisolated var encoder: JSONEncoder { JSONEncoder.createEncoder() }
    public nonisolated var formatter: DateFormatter { DateFormatter.createFormatter() }

    init() {
        Logger.core.info("\(String.logHeader()) Started")
    }
}

