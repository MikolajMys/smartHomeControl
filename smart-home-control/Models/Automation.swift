//
//  Automation.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import Foundation
import SwiftData

@Model
final class Automation {
    var id: UUID = UUID()
    var name: String
    var triggerType: TriggerType
    var triggerValue: String = ""
    var isEnabled: Bool = true
    var createdAt: Date = Date()

    @Relationship(deleteRule: .cascade) var actions: [SceneAction] = []

    init(name: String, triggerType: TriggerType) {
        self.name = name
        self.triggerType = triggerType
    }
}
