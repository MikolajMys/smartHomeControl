//
//  RoomCreateView.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftUI
import SwiftData

struct RoomCreateView: View {
    let room: Room?
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ViewModel

    init(room: Room? = nil) {
        self.room = room
        _viewModel = State(initialValue: ViewModel(room: room))
    }

    var body: some View {
        @Bindable var vm = viewModel
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Name", text: $vm.name)
                }
                Section("Icon") {
                    IconPicker(selection: $vm.selectedIcon)
                        .padding(.vertical, 4)
                }
            }
            .navigationTitle(viewModel.isEditing ? "Edit Room" : "New Room")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.save(context: modelContext)
                        dismiss()
                    }
                    .disabled(viewModel.name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

#Preview {
    RoomCreateView()
        .modelContainer(.preview)
}
