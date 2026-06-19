//
//  Room.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import Foundation
import SwiftData

@Model
final class Room {
    var id: UUID = UUID()
    var name: String
    var iconName: String = "house"
    var sortOrder: Int = 0

    @Relationship(deleteRule: .nullify, inverse: \Device.room) var devices: [Device] = []

    init(name: String, iconName: String = "house", sortOrder: Int = 0) {
        self.name = name
        self.iconName = iconName
        self.sortOrder = sortOrder
    }
}
