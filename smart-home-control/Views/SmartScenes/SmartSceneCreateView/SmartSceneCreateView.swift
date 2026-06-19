//
//  SmartSceneCreateView.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftUI
import SwiftData

struct SmartSceneCreateView: View {
    let scene: SmartScene?
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Device.name) private var devices: [Device]
    @Query(sort: \Automation.name) private var automations: [Automation]
    @State private var viewModel: ViewModel

    init(scene: SmartScene? = nil) {
        self.scene = scene
        _viewModel = State(initialValue: ViewModel(scene: scene))
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
                Section("Device Actions") {
                    ForEach($vm.actionDrafts) { $draft in
                        ActionDraftRow(draft: $draft, devices: devices)
                    }
                    .onDelete { viewModel.actionDrafts.remove(atOffsets: $0) }
                    Button("Add Device Action") {
                        viewModel.addActionDraft()
                    }
                }
                Section("Automation Actions") {
                    ForEach($vm.automationActionDrafts) { $draft in
                        AutomationActionDraftRow(draft: $draft, automations: automations)
                    }
                    .onDelete { viewModel.automationActionDrafts.remove(atOffsets: $0) }
                    Button("Add Automation Action") {
                        viewModel.addAutomationActionDraft()
                    }
                }
            }
            .navigationTitle(viewModel.isEditing ? "Edit Scene" : "New Scene")
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
            if let type = draft.device?.type, type.defaultUnit != nil {
                HStack {
                    Text("Value")
                    Spacer()
                    Text(String(format: "%.0f%@", draft.targetValue ?? 0, type.defaultUnit ?? ""))
                        .foregroundStyle(Color.textSecondary)
                }
                Slider(
                    value: Binding(
                        get: { draft.targetValue ?? 0 },
                        set: { draft.targetValue = $0 }
                    ),
                    in: type == .thermostat ? 10.0...35.0 : 0.0...100.0
                )
                .tint(Color.accentBlue)
            }
        }
    }
}

private struct AutomationActionDraftRow: View {
    @Binding var draft: AutomationActionDraft
    let automations: [Automation]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Picker("Automation", selection: $draft.automation) {
                Text("None").tag(Automation?.none)
                ForEach(automations) { automation in
                    Text(automation.name).tag(Automation?.some(automation))
                }
            }
            Toggle(draft.targetIsEnabled ? "Enable automation" : "Disable automation",
                   isOn: $draft.targetIsEnabled)
        }
    }
}

#Preview {
    SmartSceneCreateView()
        .modelContainer(.preview)
}
