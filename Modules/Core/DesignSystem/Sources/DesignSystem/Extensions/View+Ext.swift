//
//  View+Ext.swift
//  DesignSystem
//
//  Created by Sergey Kemenov on 16.02.2026.
//

import SwiftUI

public extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
