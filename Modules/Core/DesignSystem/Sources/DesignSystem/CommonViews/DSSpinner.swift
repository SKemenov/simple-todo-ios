//
//  DSSpinner.swift
//  DesignSystem
//
//  Created by Sergey Kemenov on 03.03.2026.
//

import SwiftUI

/// A SwiftUI view modifier that displays a spinning progress indicator.
/// - Parameters:
///   - isPresented: A Boolean value that determines whether the spinner is visible.
///
/// - Returns: A view with an overlaid spinning progress indicator when `isPresented` is `true`.
struct DSSpinner: ViewModifier {
    /// A Boolean value that determines whether the spinner is visible.
    var isPresented: Bool
    /// A progress value that defines the fill proportion of the loading indicator.
    /// A value of `0.7` means that 70% of the full circle is displayed.
    private let progress: CGFloat = 0.28
    @State private var rotatingDegrees = 0.0

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                baseCircle
                spinner
            }
        }
    }
}

private extension DSSpinner {
    var baseCircle: some View {
        Circle()
            .stroke(.designSystem(.text(.accent)).opacity(0.3), lineWidth: .DS.Borders.large)
            .frame(width: .DS.Sizes.smallRow, height: .DS.Sizes.smallRow)
    }
    var spinner: some View {
        Circle()
            .trim(from: .zero, to: progress)
            .stroke(.designSystem(.text(.accent)), lineWidth: .DS.Borders.large)
            .frame(width: .DS.Sizes.smallRow, height: .DS.Sizes.smallRow)
            .rotationEffect(.degrees(rotatingDegrees))
            .shadow(color: .designSystem(.text(.accent)), radius: 2)
            .task(id: isPresented) {
                guard isPresented else { return }
                rotatingDegrees = 0.0
                withAnimation(.linear(duration: 0.9).repeatForever(autoreverses: false)) {
                    rotatingDegrees = 360.0
                }
            }
    }
}

extension View {
    /// A SwiftUI view modifier that displays a spinning progress indicator.
    ///
    /// Use `spinner(isPresented:)` to overlay a circular spinner on a view when a loading state is active.
    /// The `content` view has been blocking while `spinner` is presenting.
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State private var isLoading = true
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Text("Loading...")
    ///         }
    ///         .spinner(isPresented: isLoading)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: A Boolean value that determines whether the spinner is visible.
    ///
    /// - Returns: A modified view with an optional spinner overlay.
    /// - Note: The view modifier also has private property `progress` for defining the fill proportion of the loading.
    /// The progress indicator has a constant value `0.7` which means that 70% of the full circle is displayed.
    public func spinner(isPresented: Bool) -> some View {
        modifier(DSSpinner(isPresented: isPresented))
    }
}

#Preview {
    VStack { }
        .frame(width: 200, height: 200)
        .preferredColorScheme(.dark)
        .foregroundStyle(.designSystem(.text(.primary)))
        .spinner(isPresented: true)
}
