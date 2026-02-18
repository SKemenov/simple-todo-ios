//
//  ToDoDomainValidator.swift
//  DomainInterface
//
//  Created by Sergey Kemenov on 10.02.2026.
//

import Foundation
import Utilities

public struct ToDoDomainValidator {
    public init() {}
    public func validateTitle(_ title: String) -> String {
        title.trimSpaces
    }

    public func validateDescription(_ content: String) -> String {
        content.trimSpaces
    }
}
