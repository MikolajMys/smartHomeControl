//
//  DeviceCreate-ViewModel.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import Foundation
import SwiftData

extension DeviceCreateView {
    @Observable
    class ViewModel {
        var name: String = ""
        var selectedType: DeviceType = .light
        var selectedRoom: Room? = nil
        var initialValue: Double = 0

        var isEditing: Bool { editingDevice != nil }

        private let editingDevice: Device?

        init(device: Device? = nil) {
            editingDevice = device
            if let device {
                name = device.name
                selectedType = device.type
                selectedRoom = device.room
                initialValue = device.currentValue ?? 0
            }
        }

        func save(context: ModelContext) {
            if let device = editingDevice {
                device.name = name.trimmingCharacters(in: .whitespaces)
                device.type = selectedType
                device.iconName = selectedType.defaultIconName
                device.unit = selectedType.defaultUnit
                device.room = selectedRoom
                device.currentValue = initialValue > 0 ? initialValue : nil
                device.updatedAt = Date()
            } else {
                let device = Device(name: name.trimmingCharacters(in: .whitespaces), type: selectedType)
                device.room = selectedRoom
                if initialValue > 0 {
                    device.currentValue = initialValue
                }
                context.insert(device)
            }
            try? context.save()
        }
    }
}
