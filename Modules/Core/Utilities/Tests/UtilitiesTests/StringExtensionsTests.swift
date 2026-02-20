//
//  StringExtensionsTests.swift
//  Utilities
//
//  Created by Sergey Kemenov on 19.02.2026.
//

import Testing
@testable import Utilities
import Foundation

@Suite("String Extensions")
struct StringExtensionsTests {
    @Test("makeDateFromStamp parses valid string", arguments: [
        "01/01/2026",
        "15/07/2025",
    ])
    func makeDateFromStamp_valid(input: String) {
       var sut = input.makeDateFromStamp()

        // We expect date in correct format it shouldn't fall back into current date
        #expect(sut != Current.date())
        // We expect a date on the local midnight of that day, so need to use .inLocalTime()
        sut = sut.inLocalTime()
        #expect(Calendar.current.component(.day, from: sut) == Int(input.prefix(2))!)
        #expect(Calendar.current.component(.month, from: sut) == Int(input.prefix(5).suffix(2))!)
        #expect(Calendar.current.component(.year, from: sut) == Int(input.suffix(4))!)
    }

    @Test("makeDateFromStamp falls back to now on invalid input")
    func makeDateFromStamp_invalid() {
        let now = Current.date()
        // Expect to use Current.date() for falls back
        let sut = "invalid-date".makeDateFromStamp()

        #expect(sut > now.addingTimeInterval(-1))
        #expect(sut < now.addingTimeInterval(1))
    }

    @Test("logHeader produces expected format")
    func logHeader() {
        var sut  = ""
        sut = String.logHeader(fileID: "SomeFile.swift", function: "init()")
        #expect(sut.hasPrefix("[SomeFile.init]"))

        sut = String.logHeader(fileID: "SomeFile.swift", function: "someFunction(param:)")
        #expect(sut.hasPrefix("[SomeFile.someFunction(param:)]"))

        sut = String.logHeader(fileID: "SomeFile.swift", function: "execute(_:)")
        #expect(sut.hasPrefix("[SomeFile.execute(_:)]"))
    }
}
