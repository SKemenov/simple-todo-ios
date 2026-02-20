//
//  Font+Ext.swift
//  DesignSystem
//
//  Created by Sergey Kemenov on 08.02.2026.
//

import SwiftUI

extension Font {
    public static func designSystem(_ token: DesignSystem.Fonts) -> Self {
        token.font
    }
}
