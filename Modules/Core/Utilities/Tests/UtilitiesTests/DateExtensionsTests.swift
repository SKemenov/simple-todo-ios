//
//  DateExtensionsTests.swift
//  Utilities
//
//  Created by Sergey Kemenov on 19.02.2026.
//


import Testing
@testable import Utilities
import Foundation

@Suite("Date Extensions")
struct DateExtensionsTests {

    // Helper to create controlled dates
    private let referenceInterval: TimeInterval
    private let referenceDate: Date
    private let mockTimeZoneInterval: TimeInterval

    init() {
        self.referenceInterval = 1_767_214_800 // Unix time for 2026-01-01 00:00:00 UTC
        self.referenceDate = Date(timeIntervalSince1970: referenceInterval) // 2026-01-01 00:00:00 UTC
        self.mockTimeZoneInterval = Current.timeZoneInterval
    }
    @Test("inLocalTime / inUTC round-trip")
    func timeZoneRoundTrip() {
        let original = referenceDate

        let local = original.inLocalTime()
        let sut = local.inUTC()
        #expect(sut == original, "Round-trip through local time should preserve original UTC date")
    }

    @Test("startOfUTCDay returns midnight UTC")
    func startOfUTCDay() {
        let date = Date(timeIntervalSince1970: referenceInterval + mockTimeZoneInterval) // 2026-01-01 10:00:00 UTC

        let sut = date.startOfUTCDay()
        #expect(sut.timeIntervalSince1970 == referenceInterval)
    }

    @Test("startOfLocalDay adjusts to local midnight")
    func startOfLocalDay() {
        // We cannot fully mock Calendar & TimeZone in pure unit test without dependency injection
        // But we can at least check that it calls inLocalTime() + startOfDay
        let date = referenceDate.addingTimeInterval(mockTimeZoneInterval)

        let sut = date.startOfLocalDay()
        #expect(sut == date)
        #expect(sut.startOfUTCDay() == referenceDate.startOfUTCDay())
        #expect(sut.addingTimeInterval(mockTimeZoneInterval).startOfUTCDay() == referenceDate.startOfUTCDay())
    }

    @Test("createDateStamp formats correctly", arguments: [
        (Date(timeIntervalSince1970: 1_767_214_800), "01/01/2026"),      // UTC midnight → local
        (Date(timeIntervalSince1970: 1_767_301_200), "02/01/2026"),      // next day
    ])
    func dateStamp(input: Date, expected: String) {
        // Because Current.formatter & .startOfLocalDay() are used
        let sut = input.createDateStamp()
        #expect(sut == expected)
    }

    @Test("addMonth preserves day-of-month when possible", arguments: [
        (Date(timeIntervalSince1970: 1_767_214_800), 1,  1_769_893_200), // Jan 01 → Feb 01
        (Date(timeIntervalSince1970: 1_769_893_200), -1, 1_767_214_800), // Feb 01 → Jan 01
        (Date(timeIntervalSince1970: 1_769_806_800), 1,  1_772_226_000), // Jan 31 → Feb 29/28 (leap year handling)
    ])
    func addMonth(input: Date, months: Int, expectedInterval: TimeInterval) {
        let sut = input.addMonth(months)
        #expect(abs(sut.timeIntervalSince1970 - expectedInterval) < 1.0,
                "Expected approximate match within 1 second (DST / calendar variance)")
    }

    @Test("addDay shifts by exact 24h intervals", arguments: [
        (0, 0.0),
        (1, 86_400.0),
        (-3, -259_200.0),
        (7, 604_800.0),
    ])
    func addDay(days: Int, expectedDelta: TimeInterval) {
        let start = referenceDate

        let sut = start.addDay(days)
        #expect(sut.timeIntervalSince(start) == expectedDelta)
    }

    @Test("addSec is thin wrapper around addingTimeInterval")
    func addSec() {
        let start = referenceDate

        let sut = start.addSec(60*60) // +1 hour
        #expect(sut.timeIntervalSince(start) == 60*60)
    }
}
