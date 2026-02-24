//
//  ToDoListScreen.swift
//  BlogPostFeature
//
//  Created by Sergey Kemenov on 07.02.2026.
//

import SwiftUI
import DesignSystem

public struct ToDoListScreen: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var vm: ToDoListViewModel
    @State private var cardSizes: [UUID: CGSize] = [:]

    public init(vm: ToDoListViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }
    
    public var body: some View {
        NavigationStack {
            Group {
                if vm.hasTodos {
                    VStack(spacing: .DS.Spacing.xLarge) {

                        DSSearchBar(text: $vm.searchText)

                        if vm.hasFilteredTodos {
                            toDosList
                        } else {
                            noFilteredTodos
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.designSystem(.background(.primary)))
                } else {
                    noTodos
                }
            }
            .simultaneousGesture(DragGesture().onChanged { _ in hideKeyboard() })
            .navigationTitle(LocalizedStringResource("ToDos", bundle: .module))
            .overlay(alignment: .bottom) { footer }
        }
        .background(.designSystem(.background(.primary)))
        .overlay { progress }
        .overlay { errorView }
        .onPreferenceChange(SizePreferenceKey.self) { cardSizes = $0 }
        .task {
            await vm.loadData()
        }
        .refreshable {
            await vm.loadData()
        }
    }
}

private extension ToDoListScreen {
    var toDosList: some View {
        ScrollView {
            LazyVStack(spacing: .zero) {
                ForEach(vm.filteredTodos) { toDo in
                    ToDoCard(toDo, isLast: toDo == vm.filteredTodos.last) {
                        Task { try await vm.completeToDo(toDo) }
                    }
                    .background { backgroundGeometryReader(for: toDo.id) }
                    .contextMenu {
                        contextMenu(for: toDo)
                    } preview: {
                        preview(for: toDo)
                    }
                }
            }
            .padding(.bottom, .DS.Sizes.footer)
        }
        .background(.designSystem(.background(.primary)))
    }

    var footer: some View {
        ListFooter(counter: vm.todosCount) {
            coordinator.push(page: .createToDo)
        }
    }

    var noTodos: some View {
        DSEmptyState()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.designSystem(.background(.primary)))
    }

    var noFilteredTodos: some View {
        DSEmptyState(isSearch: true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.designSystem(.background(.primary)))
    }

    @ViewBuilder
    var progress: some View {
        if vm.isLoading {
            ProgressView()
        }
    }

    @ViewBuilder
    var errorView: some View {
        if let error = vm.errorMessage {
            DSError(message: error) {
                Task { await vm.loadData() }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.designSystem(.background(.primary)))
        }
    }

    func backgroundGeometryReader(for id: UUID) -> some View {
        GeometryReader { proxy in
            Color.clear
                .preference(
                    key: SizePreferenceKey.self,
                    value: [id: proxy.size]
                )
        }
    }

    @ViewBuilder
    func contextMenu(for toDo: UIModel.ToDo) -> some View {
        Button(LocalizedStringResource("Edit", bundle: .module), systemImage: .DS.Icons.edit) {
            coordinator.push(page: .toDoDetail(model: toDo))
        }
        ShareLink(LocalizedStringResource("Share", bundle: .module), item: vm.exportToDo(toDo))
        Button(LocalizedStringResource("Delete", bundle: .module), systemImage: .DS.Icons.delete, role: .destructive) {
            Task { try await vm.deleteToDo(id: toDo.id) }
        }
    }

    @ViewBuilder
    func preview(for toDo: UIModel.ToDo) -> some View {
        let previewSize = cardSizes[toDo.id] ?? CGSize(width: 400, height: 50)
        ToDoCardDetail(toDo)
            .padding(.horizontal, .DS.Spacing.xLarge)
            .padding(.vertical, .DS.Spacing.large)
            .frame(width: previewSize.width, height: previewSize.height)
            .background(.designSystem(.background(.secondary)))
    }
}

// MARK: - Helpers
struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: [UUID: CGSize] = [:]

    static func reduce(value: inout [UUID: CGSize], nextValue: () -> [UUID: CGSize]) {
        value.merge(nextValue()) { $1 }
    }
}

#if DEBUG
#Preview("ToDo List - Russian") {
    ToDoListScreen(vm: UIMockDependencyContainer().makeToDoListViewModel())
        .environmentObject(AppCoordinator(container: UIMockDependencyContainer()))
        .preferredColorScheme(.dark)
        .environment(\.locale, Locale(identifier: "RU"))
}

#Preview("ToDo List - English") {
    ToDoListScreen(vm: UIMockDependencyContainer().makeToDoListViewModel())
        .environmentObject(AppCoordinator(container: UIMockDependencyContainer()))
        .preferredColorScheme(.dark)
        .environment(\.locale, Locale(identifier: "EN"))
}
#endif
