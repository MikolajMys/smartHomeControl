//
//  Device.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import Foundation
import SwiftData

@Model
final class Device {
    var id: UUID = UUID()
    var name: String
    var type: DeviceType
    var isOnline: Bool = false
    var isOn: Bool = false
    var currentValue: Double?
    var unit: String?
    var isFavorite: Bool = false
    var iconName: String
    var createdAt: Date = Date()
    var updatedAt: Date = Date()

    @Relationship var room: Room?

    init(name: String, type: DeviceType) {
        self.name = name
        self.type = type
        self.iconName = type.defaultIconName
        self.unit = type.defaultUnit
    }
}
