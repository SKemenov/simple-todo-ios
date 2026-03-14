//
//  ToDoListScreen.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 07.02.2026.
//

import SwiftUI
import DesignSystem

public struct ToDoListScreen: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var vm: ToDoListViewModel

    public init(vm: ToDoListViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    public var body: some View {
        VStack(spacing: .DS.Spacing.xLarge) {
            DSSearchBar(text: $vm.searchText)
            toDosList
                .overlay { noFilteredTodos }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.designSystem(.background(.primary)))
        .simultaneousGesture(DragGesture().onChanged { _ in hideKeyboard() })
        .navigationTitle(.listViewNavTitle)
        .overlay { noTodos }
        .overlay(alignment: .bottom) { footer }
        .background(.designSystem(.background(.primary)))
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
                    } onDelete: {
                        Task { try await vm.deleteToDo(id: toDo.id) }
                    }
                }
            }
            .padding(.bottom, .DS.Sizes.footer)
        }
        .background(.designSystem(.background(.primary)))
    }

    @ViewBuilder var footer: some View {
        ListFooter(counter: vm.todosCount) {
            coordinator.push(page: .createToDo)
        }
    }

    @ViewBuilder var noTodos: some View {
        if vm.isTodosEmpty {
            DSEmptyState()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.designSystem(.background(.primary)))
        }
    }

    @ViewBuilder var noFilteredTodos: some View {
        if vm.isFilteredTodosEmpty {
            DSEmptyState(isSearch: true)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.designSystem(.background(.primary)))
        }
    }
}

#if DEBUG
#Preview("ToDo List - Russian") {
    NavigationStack {
        ToDoListScreen(vm: UIMockAppDIContainer().makeToDoListViewModel())
            .environmentObject(AppCoordinator(container: UIMockAppDIContainer()))
            .preferredColorScheme(.dark)
            .environment(\.locale, Locale(identifier: "RU"))
    }
}

#Preview("ToDo List - English") {
    NavigationStack {
        ToDoListScreen(vm: UIMockAppDIContainer().makeToDoListViewModel())
            .environmentObject(AppCoordinator(container: UIMockAppDIContainer()))
            .preferredColorScheme(.dark)
            .environment(\.locale, Locale(identifier: "EN"))
    }
}
#endif
