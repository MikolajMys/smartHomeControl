//
//  DevicesList-ViewModel.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import Foundation
import SwiftData

extension DevicesListView {
    @Observable
    class ViewModel {
        var context: ModelContext?
        var searchText: String = ""

        func deleteDevice(_ device: Device) {
            context?.delete(device)
            try? context?.save()
        }

        func toggleFavorite(_ device: Device) {
            device.isFavorite.toggle()
            device.updatedAt = Date()
            try? context?.save()
        }
    }
}
