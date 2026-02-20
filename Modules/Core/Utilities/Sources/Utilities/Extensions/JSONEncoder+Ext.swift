//
//  JSONEncoder+Ext.swift
//  Utilities
//
//  Created by Sergey Kemenov on 07.02.2026.
//

import Foundation

public extension JSONEncoder {
    static func createEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        return encoder
    }
}
