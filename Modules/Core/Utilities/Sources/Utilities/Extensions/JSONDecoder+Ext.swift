//
//  JSONDecoder+Ext.swift
//  Utilities
//
//  Created by Sergey Kemenov on 07.02.2026.
//

import Foundation

public extension JSONDecoder {
    static func createDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }
}
