//
//  EnergyReading.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import Foundation
import SwiftData

@Model
final class EnergyReading {
    var id: UUID = UUID()
    var timestamp: Date
    var valueKWh: Double

    @Relationship var device: Device?

    init(timestamp: Date, valueKWh: Double) {
        self.timestamp = timestamp
        self.valueKWh = valueKWh
    }
}
