//
//  String+Ext.swift
//  DesignSystem
//
//  Created by Sergey Kemenov on 09.02.2026.
//

import Foundation

// MARK: - Icon name's tokens
extension String {
    public enum DS {
        /// Predefined Icons names (preferably for contextMenu labels)
        public enum Icons { }
    }
}

extension String.DS.Icons: CaseIterable {
    /// `complete` for "checkmark.circle"
    public static let complete: String = "checkmark.circle"

    /// `incomplete` for "circle"
    public static let incomplete: String = "circle"

    /// `create` for "square.and.pencil"
    public static let create: String = "square.and.pencil"

    /// `share` for "square.and.arrow.up"
    public static let share: String = "square.and.arrow.up"

    /// `edit` for "long.text.page.and.pencil"
    public static let edit: String = "long.text.page.and.pencil"

    /// `delete` for "trash"
    public static let delete: String = "trash"

    /// `dictate` for "microphone.fill"
    public static let dictate: String = "microphone.fill"

    /// `search` for "magnifyingglass"
    public static let search: String = "magnifyingglass"

    /// `warning` for "exclamationmark.triangle"
    public static let warning: String = "exclamationmark.triangle"

    /// `empty` for "doc.text"
    public static let empty: String = "doc.text"

    /// `close` for "xmark.circle.fill"
    public static let close: String = "xmark.circle.fill"
}
