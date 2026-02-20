//
//  Configuration.swift
//  DesignSystem
//
//  Created by Sergey Kemenov on 07.02.2026.
//

import SwiftUI

public struct Configuration {
    public var row = DSRow.Configuration()
}

extension EnvironmentValues {
    @Entry var configuration = Configuration()
}
