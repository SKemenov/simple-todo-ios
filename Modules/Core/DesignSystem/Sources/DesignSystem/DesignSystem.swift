//
//  DesignSystem.swift
//  DesignSystem
//
//  Created by Sergey Kemenov on 07.02.2026.
//

import SwiftUI

/// For colors & fonts tokens should use `.designSystem()` methods
/// For sizes & icon names should use `.DS` enums
///
/// Please do not use base colors from this module, use tokens instead.
public struct DesignSystem {}

// MARK: - Color tokens
extension DesignSystem {
    public enum Colors {
        public enum Background {
            case primary, secondary

            var color: Color {
                switch self {
                case .primary: Color("dsBlack", bundle: .module)
                case .secondary: Color("dsGray", bundle: .module)
                }
            }
        }

        public enum Text {
            case accent, error, primary, secondary

            var color: Color {
                switch self {
                case .accent: Color("dsYellow", bundle: .module)
                case .error: Color("dsRed", bundle: .module)
                case .primary: Color("dsWhite", bundle: .module)
                case .secondary: Color("dsWhiteWithOpacity", bundle: .module)
                }
            }
        }

        public enum Border {
            case primary

            var color: Color {
                switch self {
                case .primary: Color("dsDarkGray", bundle: .module)
                }
            }
        }

        public enum Token {
            case background(Background)
            case text(Text)
            case border(Border)

            var color: Color {
                switch self {
                case let .background(token): token.color
                case let .text(token): token.color
                case let .border(token): token.color
                }
            }
        }
    }
}

// MARK: - Font tokens
extension DesignSystem {
    public enum Fonts {
        case titleLarge, title, callout, headline, body, caption, icon, iconLarge

        var font: Font {
            switch self {
                /// 34pt, weight: .bold
            case .titleLarge: .system(size: 34, weight: .bold)
                /// 22pt, weight: .regular
            case .title: .system(size: 22, weight: .regular)
                /// 17pt, weight: .regular
            case .callout: .system(size: 17, weight: .regular)
                /// 16pt, weight: .medium
            case .headline: .system(size: 16, weight: .medium)
                /// 16pt, weight: .regular
            case .body: .system(size: 16, weight: .regular)
                /// 12pt, weight: .regular
            case .caption: .system(size: 12, weight: .regular)
                /// 24pt, weight: .thin
            case .icon: .system(size: 24, weight: .thin)
                /// 48pt, weight: .thin
            case .iconLarge: .system(size: 48, weight: .thin)
            }
        }
    }
}
