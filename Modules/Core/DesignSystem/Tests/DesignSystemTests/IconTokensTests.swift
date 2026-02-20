//
//  IconTokensTests.swift
//  DesignSystem
//
//  Created by Sergey Kemenov on 19.02.2026.
//


import Testing
@testable @preconcurrency import DesignSystem
import SwiftUI

@Suite("Icon Tokens Consistency")
struct IconTokensTests {
     @Test("Image and String icons match", arguments: [
        (String.DS.Icons.close, Image.DS.Icons.close),
        (String.DS.Icons.create, Image.DS.Icons.create),
        (String.DS.Icons.complete, Image.DS.Icons.complete),
        (String.DS.Icons.delete, Image.DS.Icons.delete),
        (String.DS.Icons.dictate, Image.DS.Icons.dictate),
        (String.DS.Icons.edit, Image.DS.Icons.edit),
        (String.DS.Icons.empty, Image.DS.Icons.empty),
        (String.DS.Icons.incomplete, Image.DS.Icons.incomplete),
        (String.DS.Icons.search, Image.DS.Icons.search),
        (String.DS.Icons.share, Image.DS.Icons.share),
        (String.DS.Icons.warning, Image.DS.Icons.warning),
    ])
    func iconNamesMatch(iconName: String, icon: Image) {
        #expect(Image(systemName: iconName) == icon)
    }
}
