//
//  Date+Ext.swift
//  Utilities
//
//  Created by Sergey Kemenov on 07.02.2026.
//

import Foundation

public extension Date {
    /// Converts the current date to the local time zone using `Current.timeZoneInterval`.
    /// - Returns: A `Date` adjusted for the local time zone.
    func toLocalDate() -> Self {
        self.addingTimeInterval(Current.timeZoneInterval)
    }

    /// Converts the current date to the UTC time zone using `Current.timeZoneInterval`.
    /// - Returns: A `Date` adjusted for the UTC time zone.
    func fromLocalDate() -> Self {
        self.addingTimeInterval(-Current.timeZoneInterval)
    }

    /// Returns the first moment of a given Date, as a Date for the UTC time zone.
    func startOfUTCDay() -> Self {
        Current.calendar.startOfDay(for: self)
    }

    /// Returns the first moment of a given Date, as a Date for the local time zone.
    func startOfLocalDay() -> Self {
        self.startOfUTCDay().toLocalDate()
    }

    func createDateStamp() -> String {
        Current.formatter.string(from: self.startOfLocalDay())
    }

    /// Adds a specified number of months to the selected date.
    /// - Parameter number: The number of months to add (can be negative for subtraction).
    /// - Returns: A new `Date` advanced by the specified number of months, or `Current.date()` if the calculation fails.
    func addMonth(_ number: Int) -> Self {
        Current.calendar.date(byAdding: .month, value: number, to: self) ?? Current.date()
    }

    /// Adds a specified number of days to the selected date.
    /// - Parameter number: The number of days to add (can be negative for subtraction).
    /// - Returns: A new `Date` advanced by the specified number of days.
    func addDay(_ number: Int) -> Self {
        Current.calendar.date(byAdding: .day, value: number, to: self) ?? Current.date()
    }

    /// Adds a specified number of seconds to the selected date.
    /// - Parameter number: The number of seconds to add (can be negative for subtraction).
    /// - Returns: A new `Date` advanced by the specified number of seconds.
    func addSec(_ number: Int) -> Self {
        self.addingTimeInterval(Double(number))
    }
}
