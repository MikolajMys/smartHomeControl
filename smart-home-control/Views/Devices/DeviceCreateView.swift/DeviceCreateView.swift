//
//  DeviceCreateView.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftUI
import SwiftData

struct DeviceCreateView: View {
    let device: Device?
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Room.sortOrder) private var rooms: [Room]
    @State private var viewModel: ViewModel

    init(device: Device? = nil) {
        self.device = device
        _viewModel = State(initialValue: ViewModel(device: device))
    }

    var body: some View {
        @Bindable var vm = viewModel
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Name", text: $vm.name)
                    Picker("Type", selection: $vm.selectedType) {
                        ForEach(DeviceType.allCases, id: \.self) { type in
                            Label(type.displayName, systemImage: type.defaultIconName)
                                .tag(type)
                        }
                    }
                }

                Section("Room") {
                    Picker("Room", selection: $vm.selectedRoom) {
                        Text("None").tag(Room?.none)
                        ForEach(rooms) { room in
                            Label(room.name, systemImage: room.iconName)
                                .tag(Room?.some(room))
                        }
                    }
                }

                if vm.selectedType.defaultUnit != nil {
                    Section("Initial Value") {
                        HStack {
                            Text(vm.selectedType.defaultUnit ?? "")
                            Spacer()
                            Text(String(format: "%.1f", vm.initialValue))
                                .foregroundStyle(Color.textSecondary)
                        }
                        Slider(
                            value: $vm.initialValue,
                            in: vm.selectedType == .thermostat ? 10.0...35.0 : 0.0...100.0
                        )
                        .tint(Color.accentBlue)
                    }
                }
            }
            .navigationTitle(viewModel.isEditing ? "Edit Device" : "New Device")
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
    DeviceCreateView()
        .modelContainer(.preview)
}
