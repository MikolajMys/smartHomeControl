//
//  ProfileView.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showResetAlert = false

    var body: some View {
        List {
            Section("General") {
                LabeledContent("Version", value: "1.0.0")
            }

            Section("Data") {
                Button("Reset All Data", role: .destructive) {
                    showResetAlert = true
                }
            }

            Section("About") {
                VStack(alignment: .leading, spacing: 6) {
                    Text("SmartHome Control")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.textPrimary)
                    Text("A showcase iOS 26 smart home dashboard built with SwiftUI + SwiftData. Control devices, manage rooms, run scenes, and set up automations.")
                        .font(.caption)
                        .foregroundStyle(Color.textSecondary)
                }
                .padding(.vertical, 4)
                LabeledContent("Stack", value: "SwiftUI + SwiftData")
                LabeledContent("Platform", value: "iOS 26")
            }
        }
        .navigationTitle("Profile")
        .alert("Reset All Data?", isPresented: $showResetAlert) {
            Button("Reset", role: .destructive) { resetData() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("All devices, rooms, scenes, and automations will be deleted and replaced with sample data.")
        }
    }

    private func resetData() {
        let sceneActions  = (try? modelContext.fetch(FetchDescriptor<SceneAction>())) ?? []
        let energyReads   = (try? modelContext.fetch(FetchDescriptor<EnergyReading>())) ?? []
        let devices       = (try? modelContext.fetch(FetchDescriptor<Device>())) ?? []
        let scenes        = (try? modelContext.fetch(FetchDescriptor<SmartScene>())) ?? []
        let automations   = (try? modelContext.fetch(FetchDescriptor<Automation>())) ?? []
        let rooms         = (try? modelContext.fetch(FetchDescriptor<Room>())) ?? []

        sceneActions.forEach  { modelContext.delete($0) }
        energyReads.forEach   { modelContext.delete($0) }
        devices.forEach       { modelContext.delete($0) }
        scenes.forEach        { modelContext.delete($0) }
        automations.forEach   { modelContext.delete($0) }
        rooms.forEach         { modelContext.delete($0) }

        try? modelContext.save()
        try? SampleData.populate(modelContext)
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
    .modelContainer(.preview)
}
