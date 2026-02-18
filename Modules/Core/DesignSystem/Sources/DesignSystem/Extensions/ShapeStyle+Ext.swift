//
//  ShapeStyle+Ext.swift
//  DesignSystem
//
//  Created by Sergey Kemenov on 08.02.2026.
//

import SwiftUI

extension ShapeStyle where Self == Color {
    public static func designSystem(_ token: DesignSystem.Colors.Token) -> Self {
        token.color
    }
}
