//
//  String+Ext.swift
//  Utilities
//
//  Created by Sergey Kemenov on 19.02.2026.
//

import Foundation

public extension String {
    var trimSpaces: Self {
        self.trimmingCharacters(in: .whitespaces)
    }

    func makeDateFromStamp() -> Date {
        if let date = Current.formatter.date(from: self) {
            return date.inUTC()
        } else {
            return Current.date()
        }
    }

    static func logHeader(fileID: StaticString = #fileID, function: StaticString = #function) -> Self {
        /// Module name/File name without ext
        let fileName = String(describing: fileID).components(separatedBy: ".").first ?? String(describing: fileID)
        let functionName = String(describing: function).components(separatedBy: "()").first
            ?? String(describing: function)
        return "[\(fileName).\(functionName)]"
    }
}
