//
//  CGFloat+Ext.swift
//  DesignSystem
//
//  Created by Sergey Kemenov on 08.02.2026.
//

import Foundation

// MARK: - Size tokens
extension CGFloat {
    /// DesignSystem `CGFloat` size tokens
    public enum DS {

        /// Predefined `Sizes` sizes
        public enum Sizes { }

        /// Predefined `Spacing` sizes
        public enum Spacing { }

        /// Predefined `Corner Radius` sizes
        public enum Radiuses { }

        /// Predefined `Borders` sizes
        public enum Borders { }
    }
}

extension CGFloat.DS.Sizes {
    /// CGFloat: 24.0
    public static let icon: CGFloat = 24

    /// CGFloat: 48.0
    public static let largeIcon: CGFloat = 48

    /// CGFloat: 36.0
    public static let smallRow: CGFloat = 36

    /// CGFloat: 72.0
    public static let footer: CGFloat = 72
}

extension CGFloat.DS.Spacing {
    /// CGFloat: 4.0
    public static let xxSmall: CGFloat = 4

    /// CGFloat: 6.0
    public static let xSmall: CGFloat = 6

    /// CGFloat: 8.0
    public static let small: CGFloat = 8

    /// CGFloat: 10.0
    public static let medium: CGFloat = 10

    /// CGFloat: 12.0
    public static let large: CGFloat = 12

    /// CGFloat: 16.0
    public static let xLarge: CGFloat = 16

    /// CGFloat: 20.0
    public static let xxLarge: CGFloat = 20
}

extension CGFloat.DS.Radiuses {
    /// CGFloat: 10.0
    public static let medium: CGFloat = 10

    /// CGFloat: 12.0
    public static let large: CGFloat = 12
}

extension CGFloat.DS.Borders {
    /// CGFloat: 1.0
    public static let small: CGFloat = 1
}
