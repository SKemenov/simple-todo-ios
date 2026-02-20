//
//  CurrentWorldTests.swift
//  Utilities
//
//  Created by Sergey Kemenov on 19.02.2026.
//


import Testing
@testable import Utilities
import Foundation

@Suite("Current / World")
struct CurrentWorldTests {

    @Test("World initializes without crashing")
    func initialization() {
        _ = World()
        #expect(true)
    }

    @Test("World.date() produces expected date after setting custom one")
    func worldDateIsValid() {
        var sut = World()
        let referenceDate = Date(timeIntervalSince1970: 1_767_214_800) // Unix time for 2026-01-01 00:00:00 UTC
        sut.date = { referenceDate }
        #expect(sut.date() == referenceDate)
    }

    @Test("Current.date() compares dates correctly")
    func compareWorldDate() {
        let sut = World()
        var referenceDate: Date
        referenceDate = Date(timeIntervalSince1970: 1_767_214_800) // Unix time for 2026-01-01 00:00:00 UTC
        #expect(sut.date() > referenceDate)
        referenceDate = Date.distantPast
        #expect(sut.date() > referenceDate)
        referenceDate = Date.distantFuture
        #expect(sut.date() < referenceDate)
    }
}
