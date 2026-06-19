//
//  RoomCreate-ViewModel.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import Foundation
import SwiftData

extension RoomCreateView {
    @Observable
    class ViewModel {
        var name: String = ""
        var selectedIcon: String = "house"

        var isEditing: Bool { editingRoom != nil }
        private let editingRoom: Room?

        init(room: Room? = nil) {
            editingRoom = room
            if let room {
                name = room.name
                selectedIcon = room.iconName
            }
        }

        func save(context: ModelContext) {
            if let room = editingRoom {
                room.name = name.trimmingCharacters(in: .whitespaces)
                room.iconName = selectedIcon
            } else {
                let room = Room(
                    name: name.trimmingCharacters(in: .whitespaces),
                    iconName: selectedIcon
                )
                context.insert(room)
            }
            try? context.save()
        }
    }
}
