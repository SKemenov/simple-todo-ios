//
//  SizeTokensTests.swift
//  DesignSystem
//
//  Created by Sergey Kemenov on 19.02.2026.
//


import Testing
@testable import DesignSystem
import Foundation

@Suite("Size / Spacing Tokens")
struct SizeTokensTests {

    @Test("Sizes are correct", arguments: [
        (CGFloat.DS.Sizes.icon, 24),
        (CGFloat.DS.Sizes.largeIcon, 48),
        (CGFloat.DS.Sizes.smallRow, 36),
        (CGFloat.DS.Sizes.footer, 72),
    ])
    func sizes(sut: CGFloat, expected: CGFloat) {
        #expect(sut == expected)
    }

    @Test("Spacings are correct", arguments: [
        (CGFloat.DS.Spacing.xxSmall, 4),
        (CGFloat.DS.Spacing.xSmall, 6),
        (CGFloat.DS.Spacing.small, 8),
        (CGFloat.DS.Spacing.medium, 10),
        (CGFloat.DS.Spacing.large, 12),
        (CGFloat.DS.Spacing.xLarge, 16),
        (CGFloat.DS.Spacing.xxLarge, 20),
    ])
    func spacing(sut: CGFloat, expected: CGFloat) {
        #expect(sut == expected)
    }

    @Test("Radiuses are correct", arguments: [
        (CGFloat.DS.Radiuses.medium, 10),
        (CGFloat.DS.Radiuses.large, 12),
    ])
    func radiuses(sut: CGFloat, expected: CGFloat) {
        #expect(sut == expected)
    }
}
