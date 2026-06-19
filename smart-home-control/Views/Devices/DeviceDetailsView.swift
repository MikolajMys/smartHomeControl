//
//  DeviceDetailsView.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftUI
import SwiftData

struct DeviceDetailsView: View {
    let device: Device
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteAlert = false
    @State private var showEditSheet = false

    private var sliderRange: ClosedRange<Double> {
        device.type == .thermostat ? 10.0...35.0 : 0.0...100.0
    }

    var body: some View {
        List {
            Section("Status") {
                LabeledContent("Type", value: device.type.displayName)
                LabeledContent("Room", value: device.room?.name ?? "Unassigned")
                LabeledContent("Online", value: device.isOnline ? "Yes" : "No")
                HStack {
                    Text("Power")
                    Spacer()
                    DeviceToggle(
                        isOn: Binding(
                            get: { device.isOn },
                            set: { device.isOn = $0; device.updatedAt = Date() }
                        ),
                        isDisabled: !device.isOnline
                    )
                }
            }

            if device.type.defaultUnit != nil {
                Section("Value") {
                    HStack {
                        Text("Current")
                        Spacer()
                        if let value = device.currentValue, let unit = device.unit {
                            Text(String(format: "%.1f %@", value, unit))
                                .foregroundStyle(Color.textSecondary)
                        }
                    }
                    Slider(
                        value: Binding(
                            get: { device.currentValue ?? sliderRange.lowerBound },
                            set: { device.currentValue = $0; device.updatedAt = Date() }
                        ),
                        in: sliderRange
                    )
                    .tint(Color.accentBlue)
                }
            }

            Section {
                Button("Delete Device", role: .destructive) {
                    showDeleteAlert = true
                }
            }
        }
        .navigationTitle(device.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    device.isFavorite.toggle()
                    device.updatedAt = Date()
                    try? modelContext.save()
                } label: {
                    Image(systemName: device.isFavorite ? "star.fill" : "star")
                        .foregroundStyle(device.isFavorite ? Color.yellow : Color.textSecondary)
                }
                Button("Edit") { showEditSheet = true }
            }
        }
        .alert("Delete Device", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                modelContext.delete(device)
                try? modelContext.save()
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("\"\(device.name)\" will be permanently deleted.")
        }
        .sheet(isPresented: $showEditSheet) {
            DeviceCreateView(device: device)
        }
    }
}

#Preview {
    let container = ModelContainerSetup.previewContainer
    let device = Device(name: "AC Unit", type: .thermostat)
    device.isOnline = true
    device.isOn = true
    device.currentValue = 22.0
    container.mainContext.insert(device)
    return NavigationStack {
        DeviceDetailsView(device: device)
    }
    .modelContainer(container)
}
