//
//  RoomsList-ViewModel.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import Foundation
import SwiftData

extension RoomsListView {
    @Observable
    class ViewModel {
        var context: ModelContext?

        func deleteRoom(_ room: Room) {
            context?.delete(room)
            try? context?.save()
        }
    }
}
