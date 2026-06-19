//
//  HomeView.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allDevices: [Device]
    @Query(sort: \EnergyReading.timestamp) private var allEnergyReadings: [EnergyReading]
    @Query(sort: \SmartScene.name) private var allScenes: [SmartScene]
    @Query(sort: \Automation.name) private var allAutomations: [Automation]
    @State private var viewModel = ViewModel()
    @State private var showEditor = false

    private var activeCount: Int { allDevices.filter { $0.isOnline && $0.isOn }.count }
    private var offlineCount: Int { allDevices.filter { !$0.isOnline }.count }
    private var averageTemperature: Double? {
        let vals = allDevices
            .filter { ($0.type == .thermostat || $0.type == .sensor) && $0.isOnline }
            .compactMap(\.currentValue)
        return vals.isEmpty ? nil : vals.reduce(0, +) / Double(vals.count)
    }
    private var todayEnergyKWh: Double {
        let start = Calendar.current.startOfDay(for: Date())
        return allEnergyReadings.filter { $0.timestamp >= start }.reduce(0) { $0 + $1.valueKWh }
    }


    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(viewModel.visibleSections) { section in
                    if section.id == "stats" {
                        StatCardsGrid(
                            activeCount: activeCount,
                            offlineCount: offlineCount,
                            averageTemperature: averageTemperature,
                            averageHumidity: 47.0,
                            todayEnergyKWh: todayEnergyKWh
                        )
                    } else if section.id == "devices" {
                        DevicesSection(devices: allDevices)
                    } else if section.id == "energy" {
                        EnergyChartView(readings: allEnergyReadings)
                    } else if section.id == "scenes" {
                        HomeSceneRowView(
                            scenes: allScenes,
                            onRun: { viewModel.executeScene($0) }
                        )
                    } else if section.id == "automations" {
                        HomeAutomationRowView(
                            automations: allAutomations,
                            onToggle: { viewModel.toggleAutomation($0) }
                        )
                    }
                }
            }
            .padding()
        }
        .background(Color.surfacePrimary)
        .navigationTitle("Home")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { showEditor = true } label: {
                    Image(systemName: "slider.horizontal.3")
                }
            }
        }
        .sheet(isPresented: $showEditor) {
            HomeSectionEditorView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.modelContext = modelContext
        }
    }
}

private struct DevicesSection: View {
    let devices: [Device]
    @State private var navigateToDevices = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Devices", onSeeAll: { navigateToDevices = true })
            DeviceCardGrid(devices: devices)
        }
        .navigationDestination(isPresented: $navigateToDevices) {
            DevicesListView()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .modelContainer(.preview)
}
