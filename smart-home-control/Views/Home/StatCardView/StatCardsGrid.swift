//
//  StatCardsGrid.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftUI

struct StatCardsGrid: View {
    let activeCount: Int
    let offlineCount: Int
    let averageTemperature: Double?
    let averageHumidity: Double?
    let todayEnergyKWh: Double

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            StatCardView(
                label: "Temperature",
                value: averageTemperature.map { String(format: "%.1f°C", $0) } ?? "—",
                subtitle: "Average indoor"
            )
            StatCardView(
                label: "Humidity",
                value: averageHumidity.map { String(format: "%.0f%%", $0) } ?? "—",
                subtitle: "Average indoor"
            )
            StatCardView(
                label: "Energy",
                value: String(format: "%.1f kWh", todayEnergyKWh),
                subtitle: "Today"
            )
            StatCardView(
                label: "Active Devices",
                value: "\(activeCount)",
                subtitle: "\(offlineCount) offline"
            )
        }
    }
}
