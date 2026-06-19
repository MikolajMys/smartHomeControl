//
//  SceneAutomationAction.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 17/06/2026.
//

import Foundation
import SwiftData

@Model
final class SceneAutomationAction {
    var id: UUID = UUID()
    var targetIsEnabled: Bool

    @Relationship var automation: Automation?
    @Relationship var scene: SmartScene?

    init(targetIsEnabled: Bool) {
        self.targetIsEnabled = targetIsEnabled
    }
}
