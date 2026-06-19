//
//  HomeAutomationRowView.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 17/06/2026.
//

import SwiftUI

struct HomeAutomationRowView: View {
    let automations: [Automation]
    let onToggle: (Automation) -> Void
    @State private var navigateToAutomations = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Automations", onSeeAll: { navigateToAutomations = true })

            if automations.isEmpty {
                Text("No automations yet. Tap See All to create one.")
                    .font(.subheadline)
                    .foregroundStyle(Color.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 12)
                    .padding()
                    .background(Color.surfaceCard)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(automations.enumerated()), id: \.element.id) { index, automation in
                        AutomationCompactRow(
                            automation: automation,
                            onToggle: { onToggle(automation) }
                        )
                        if index < automations.count - 1 {
                            Divider()
                                .padding(.leading, 56)
                        }
                    }
                }
                .background(Color.surfaceCard)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .navigationDestination(isPresented: $navigateToAutomations) {
            AutomationsListView()
        }
    }
}

private struct AutomationCompactRow: View {
    let automation: Automation
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: automation.isEnabled ? "bolt.fill" : "bolt.slash")
                .font(.subheadline)
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
            }

            Spacer()

            Toggle("", isOn: Binding(
                get: { automation.isEnabled },
                set: { _ in onToggle() }
            ))
            .labelsHidden()
            .tint(Color.accentBlue)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }

    private var triggerDescription: String {
        switch automation.triggerType {
        case .time:        return automation.triggerValue.isEmpty ? "At set time" : "At \(automation.triggerValue)"
        case .temperature: return "Temp: \(automation.triggerValue)°C"
        case .humidity:    return "Humidity: \(automation.triggerValue)%"
        case .deviceState: return automation.triggerValue.isEmpty ? "Device state" : automation.triggerValue
        case .manual:      return "Manual trigger"
        }
    }
}
