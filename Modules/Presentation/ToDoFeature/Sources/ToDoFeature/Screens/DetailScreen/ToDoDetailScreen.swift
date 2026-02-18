//
//  ToDoDetailScreen.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 16.02.2026.
//

import SwiftUI
import DesignSystem

public struct ToDoDetailScreen: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @ObservedObject private var vm: ToDoDetailViewModel

    private let titlePrompt: LocalizedStringKey = "ToDo title"
    private let descriptionPrompt: LocalizedStringKey = "ToDo detail"

    public init(vm: ToDoDetailViewModel, model: UIModel.ToDo? = nil) {
        _vm = .init(wrappedValue: vm)
        vm.toDo = model
    }
    public var body: some View {
        VStack(alignment: .leading, spacing: .DS.Spacing.small) {
            todoTitle
            todoDate
            todoDescription
            Spacer()
        }
        .padding(.horizontal, .DS.Spacing.xxLarge)
        .padding(.vertical, .DS.Spacing.small)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: saveAndExit) {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Back", bundle: .module)
                    }
                    .font(.designSystem(.callout))
                }
            }
        }
        .overlay { progress }
        .task {
            await vm.loadData()
        }
    }
}

private extension ToDoDetailScreen {
    var todoTitle: some View {
        TextField(
            "",
            text: $vm.title,
            prompt: Text(titlePrompt, bundle: .module).foregroundColor(.designSystem(.text(.primary))),
            axis: .vertical
        )
        .font(.designSystem(.titleLarge))
        .foregroundStyle(.designSystem(.text(.primary)))
        .autocorrectionDisabled(false)
        .autocapitalization(.sentences)
        .keyboardType(.default)
        .onSubmit(hideKeyboard)
        .lineLimit(1...5)
    }

    var todoDate: some View {
        Text("\(vm.createdAt)")
            .font(.designSystem(.caption))
            .foregroundStyle(.designSystem(.text(.secondary)))
            .padding(.bottom, .DS.Spacing.small)
    }

    var todoDescription: some View {
        TextField(
            "",
            text: $vm.description,
            prompt: Text(descriptionPrompt, bundle: .module).foregroundColor(.designSystem(.text(.primary))),
            axis: .vertical
        )
        .font(.designSystem(.body))
        .foregroundStyle(.designSystem(.text(.primary)))
        .autocorrectionDisabled(false)
        .autocapitalization(.sentences)
        .keyboardType(.default)
        .onSubmit(hideKeyboard)
        .lineLimit(2...10)
    }

    @ViewBuilder
    var progress: some View {
        if vm.isLoading {
            ProgressView()
        }
    }

    func saveAndExit() {
        Task {
            if vm.hasChanges {
                await vm.saveData()
            }
            coordinator.pop()
        }
    }
}
