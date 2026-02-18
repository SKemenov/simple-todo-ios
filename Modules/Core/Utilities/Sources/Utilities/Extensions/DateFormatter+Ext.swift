//
//  DateFormatter+Ext.swift
//  Utilities
//
//  Created by Sergey Kemenov on 10.02.2026.
//

import Foundation

public extension DateFormatter {
    static func createFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }
}
