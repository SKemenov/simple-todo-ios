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
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var vm: ToDoListViewModel
    @State private var cardSizes: [Int: CGSize] = [:]

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
            .navigationTitle("ToDos")
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
        .task(id: scenePhase) {
            if scenePhase == .active { await vm.loadData() }
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
        HStack {
            Spacer()
            totalCount
            Spacer()
        }
        .padding(.vertical, .DS.Spacing.xxLarge)
        .background(.designSystem(.background(.secondary)))
        .overlay(alignment: .trailing) { createButton }
    }

    var noTodos: some View {
        DSEmptyStateView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.designSystem(.background(.primary)))
    }

    var noFilteredTodos: some View {
        DSEmptyStateView(isSearch: true)
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
            DSErrorView(message: error) {
                Task { await vm.loadData() }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.designSystem(.background(.primary)))
        }
    }

    var createButton: some View {
        Button {
            coordinator.push(page: .createToDo)
        } label: {
            Image.DS.Icons.create
                .font(.designSystem(.title))
                .foregroundStyle(.designSystem(.text(.accent)))
        }
        .padding()
    }

    var totalCount: some View {
        Text("\(vm.todosCount) tasks", bundle: .module)
            .font(.designSystem(.caption))
            .foregroundStyle(.designSystem(.text(.primary)))
    }

    func backgroundGeometryReader(for id: Int) -> some View {
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
        Button("Edit", systemImage: .DS.Icons.edit) {
            coordinator.push(page: .toDoDetail(model: toDo))
        }
        ShareLink("Share", item: vm.exportToDo(toDo))
        Button("Delete", systemImage: .DS.Icons.delete, role: .destructive) {
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
    static var defaultValue: [Int: CGSize] = [:]

    static func reduce(value: inout [Int: CGSize], nextValue: () -> [Int: CGSize]) {
        value.merge(nextValue()) { $1 }
    }
}
