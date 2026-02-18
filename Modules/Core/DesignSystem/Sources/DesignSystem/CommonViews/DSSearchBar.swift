//
//  DSSearchBar.swift
//  DesignSystem
//
//  Created by Sergey Kemenov on 16.02.2026.
//

import SwiftUI

public struct DSSearchBar: View {
    @Binding var searchText: String

    public init(text: Binding<String>) {
        _searchText = text
    }

    public var body: some View {
        HStack(spacing: .DS.Spacing.xxSmall) {
            Image.DS.Icons.search

            searchTextField

            if searchText.isEmpty {
                Image.DS.Icons.dictate
            } else {
                Button(action: cancelSearching) {
                    Image.DS.Icons.close
                }
            }
        }
        .searchBarStyle()
    }
}

private extension DSSearchBar {
    var searchTextField: some View {
        TextField("", text: $searchText, prompt: Text("Search"))
            .font(.designSystem(.body))
            .foregroundStyle(.designSystem(.text(.primary)))
            .autocorrectionDisabled(true)
            .autocapitalization(.none)
            .keyboardType(.default)
            .onSubmit(hideKeyboard)
    }

    func cancelSearching() {
        searchText = String()
        hideKeyboard()
    }
}

private extension View {
    func searchBarStyle() -> some View {
        font(.designSystem(.body))
            .foregroundStyle(.designSystem(.text(.secondary)))
            .padding(.horizontal, .DS.Spacing.xSmall)
            .padding(.vertical, .DS.Spacing.small)
            .frame(height: .DS.Sizes.smallRow)
            .background(.designSystem(.background(.secondary)), in: RoundedRectangle(cornerRadius: .DS.Radiuses.medium))
            .padding(.horizontal, .DS.Spacing.xxLarge)
    }
}


#Preview {
    VStack {
        DSSearchBar(text: .constant(""))
        DSSearchBar(text: .constant("SOME text"))
    }
    .padding(.vertical, 44)
    .preferredColorScheme(.dark)
}
