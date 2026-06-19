//
//  AutomationsListView.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftUI
import SwiftData

struct AutomationsListView: View {
    @Query(sort: \Automation.name) private var automations: [Automation]
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ViewModel()
    @State private var showCreateSheet = false
    @State private var editingAutomation: Automation? = nil

    var body: some View {
        List {
            ForEach(automations) { automation in
                AutomationRowView(automation: automation) {
                    viewModel.toggleEnabled(automation)
                }
                .swipeActions(edge: .leading) {
                    Button { editingAutomation = automation } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.orange)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        viewModel.deleteAutomation(automation)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .overlay {
            if automations.isEmpty {
                EmptyStateView(
                    iconName: "bolt.slash",
                    title: "No Automations",
                    message: "Tap + to automate your home with time or sensor triggers."
                )
            }
        }
        .navigationTitle("Automations")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { showCreateSheet = true } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showCreateSheet) {
            AutomationCreateView()
        }
        .sheet(item: $editingAutomation) { automation in
            AutomationCreateView(automation: automation)
        }
        .onAppear { viewModel.context = modelContext }
    }
}

private struct AutomationRowView: View {
    let automation: Automation
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: automation.isEnabled ? "bolt.fill" : "bolt.slash")
                .font(.title3)
                .foregroundStyle(automation.isEnabled ? Color.accentBlue : Color.textSecondary)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(automation.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.textPrimary)
                Text(triggerDescription)
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
                Text("\(automation.actions.count) action\(automation.actions.count == 1 ? "" : "s")")
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
            }

            Spacer()

            Toggle("", isOn: Binding(
                get: { automation.isEnabled },
                set: { _ in onToggle() }
            ))
            .labelsHidden()
            .tint(Color.accentBlue)
        }
        .padding(.vertical, 4)
    }

    private var triggerDescription: String {
        switch automation.triggerType {
        case .time:       return automation.triggerValue.isEmpty ? "At set time" : "At \(automation.triggerValue)"
        case .temperature: return "Temp: \(automation.triggerValue)°C"
        case .humidity:   return "Humidity: \(automation.triggerValue)%"
        case .deviceState: return automation.triggerValue.isEmpty ? "Device state" : automation.triggerValue
        case .manual:     return "Manual trigger"
        }
    }
}

#Preview {
    NavigationStack {
        AutomationsListView()
    }
    .modelContainer(.preview)
}
