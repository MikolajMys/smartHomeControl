//
//  AutomationCreateView.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftUI
import SwiftData

struct AutomationCreateView: View {
    let automation: Automation?
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Device.name) private var devices: [Device]
    @State private var viewModel: ViewModel

    init(automation: Automation? = nil) {
        self.automation = automation
        _viewModel = State(initialValue: ViewModel(automation: automation))
    }

    var body: some View {
        @Bindable var vm = viewModel
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Name", text: $vm.name)
                    Picker("Trigger", selection: $vm.triggerType) {
                        Text("Manual").tag(TriggerType.manual)
                        Text("Time").tag(TriggerType.time)
                        Text("Temperature").tag(TriggerType.temperature)
                        Text("Humidity").tag(TriggerType.humidity)
                        Text("Device State").tag(TriggerType.deviceState)
                    }
                }

                TriggerConfigSection(vm: vm, devices: devices)

                Section("Actions") {
                    ForEach($vm.actionDrafts) { $draft in
                        ActionDraftRow(draft: $draft, devices: devices)
                    }
                    .onDelete { viewModel.actionDrafts.remove(atOffsets: $0) }
                    Button("Add Action") {
                        viewModel.addActionDraft()
                    }
                }
            }
            .navigationTitle(viewModel.isEditing ? "Edit Automation" : "New Automation")
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

private struct TriggerConfigSection: View {
    @Bindable var vm: AutomationCreateView.ViewModel
    let devices: [Device]

    var body: some View {
        switch vm.triggerType {
        case .time:
            Section("Trigger Time") {
                DatePicker("Time", selection: $vm.triggerDate, displayedComponents: .hourAndMinute)
            }
        case .temperature:
            Section("Trigger Condition") {
                HStack {
                    Text("Threshold (°C)")
                    Spacer()
                    TextField("22", text: $vm.triggerValue)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 60)
                }
            }
        case .humidity:
            Section("Trigger Condition") {
                HStack {
                    Text("Threshold (%)")
                    Spacer()
                    TextField("50", text: $vm.triggerValue)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 60)
                }
            }
        case .deviceState:
            Section("Trigger Device") {
                Picker("Device", selection: $vm.triggerDevice) {
                    Text("None").tag(Device?.none)
                    ForEach(devices) { device in
                        Label(device.name, systemImage: device.iconName)
                            .tag(Device?.some(device))
                    }
                }
            }
        case .manual:
            EmptyView()
        }
    }
}

private struct ActionDraftRow: View {
    @Binding var draft: ActionDraft
    let devices: [Device]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Picker("Device", selection: $draft.device) {
                Text("None").tag(Device?.none)
                ForEach(devices) { device in
                    Label(device.name, systemImage: device.iconName)
                        .tag(Device?.some(device))
                }
            }
            Toggle("Turn On", isOn: $draft.targetIsOn)
        }
    }
}

#Preview {
    AutomationCreateView()
        .modelContainer(.preview)
}
