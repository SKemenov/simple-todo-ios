//
//  Image+Ext.swift
//  DesignSystem
//
//  Created by Sergey Kemenov on 08.02.2026.
//

import SwiftUI

// MARK: - Image tokens
extension Image {
    /// DesignSystem `Image` tokens
    public enum DS {

        /// Predefined Icons names
        public enum Icons { }
    }
}

extension Image.DS.Icons {
    /// SF symbol for "checkmark.circle"
    public static let complete: Image = Image(systemName: .DS.Icons.complete)

    /// SF symbol for "circle"
    public static let incomplete: Image = Image(systemName: .DS.Icons.incomplete)

    /// SF symbol for "square.and.pencil"
    public static let create: Image = Image(systemName: .DS.Icons.create)

    /// SF symbol for "square.and.arrow.up"
    public static let share: Image = Image(systemName: .DS.Icons.share)

    /// SF symbol for "long.text.page.and.pencil"
    public static let edit: Image = Image(systemName: .DS.Icons.edit)

    /// SF symbol for "trash"
    public static let delete: Image = Image(systemName: .DS.Icons.delete)

    /// SF symbol for "microphone.fill"
    public static let dictate: Image = Image(systemName: .DS.Icons.dictate)

    /// SF symbol for "magnifyingglass"
    public static let search: Image = Image(systemName: .DS.Icons.search)

    /// SF symbol for "exclamationmark.triangle"
    public static let warning: Image = Image(systemName: .DS.Icons.warning)

    /// SF symbol for "doc.text"
    public static let empty: Image = Image(systemName: .DS.Icons.empty)

    /// SF symbol for "xmark.circle.fill"
    public static let close: Image = Image(systemName: .DS.Icons.close)
}
