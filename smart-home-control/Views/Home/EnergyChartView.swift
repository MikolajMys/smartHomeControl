//
//  EnergyChartView.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftUI
import Charts

struct EnergyChartView: View {
    let readings: [EnergyReading]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Energy — last 12h")

            if readings.isEmpty {
                Text("No energy data")
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
                    .frame(maxWidth: .infinity, minHeight: 150, alignment: .center)
            } else {
                Chart {
                    ForEach(readings) { reading in
                        BarMark(
                            x: .value("Time", reading.timestamp, unit: .hour),
                            y: .value("kWh", reading.valueKWh)
                        )
                        .foregroundStyle(Color.accentBlue)
                        .cornerRadius(4)
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 5)) { value in
                        AxisGridLine()
                        AxisValueLabel {
                            if let date = value.as(Date.self) {
                                let h = Calendar.current.component(.hour, from: date)
                                Text("\(h):00")
                                    .font(.caption2)
                                    .foregroundStyle(Color.textSecondary)
                            }
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisGridLine()
                        AxisValueLabel {
                            if let v = value.as(Double.self) {
                                Text(String(format: "%.1f", v))
                                    .font(.caption2)
                                    .foregroundStyle(Color.textSecondary)
                            }
                        }
                    }
                }
                .frame(height: 150)
            }
        }
        .padding()
        .background(Color.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    let cal = Calendar.current
    let now = Date()
    let endHour = cal.date(from: cal.dateComponents([.year, .month, .day, .hour], from: now))!
    let readings: [EnergyReading] = (0..<12).map { i in
        EnergyReading(
            timestamp: endHour.addingTimeInterval(Double(i - 12) * 3600),
            valueKWh: Double.random(in: 0.5...2.5)
        )
    }
    return EnergyChartView(readings: readings)
        .padding()
        .background(Color.surfacePrimary)
}
