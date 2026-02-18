//
//  Color+Ext.swift
//  DesignSystem
//
//  Created by Sergey Kemenov on 08.02.2026.
//

import SwiftUI

extension Color {
    public static func designSystem(_ token: DesignSystem.Colors.Token) -> Self {
        token.color
    }
}
