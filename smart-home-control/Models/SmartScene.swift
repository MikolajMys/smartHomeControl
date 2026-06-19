//
//  SmartScene.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import Foundation
import SwiftData

@Model
final class SmartScene {
    var id: UUID = UUID()
    var name: String
    var iconName: String = "sparkles"

    @Relationship(deleteRule: .cascade, inverse: \SceneAction.scene) var actions: [SceneAction] = []
    @Relationship(deleteRule: .cascade, inverse: \SceneAutomationAction.scene) var automationActions: [SceneAutomationAction] = []

    init(name: String, iconName: String = "sparkles") {
        self.name = name
        self.iconName = iconName
    }
}
