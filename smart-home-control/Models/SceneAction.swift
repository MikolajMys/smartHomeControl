//
//  SceneAction.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import Foundation
import SwiftData

@Model
final class SceneAction {
    var id: UUID = UUID()
    var targetIsOn: Bool
    var targetValue: Double?

    @Relationship var device: Device?
    @Relationship var scene: SmartScene?

    init(targetIsOn: Bool, targetValue: Double? = nil) {
        self.targetIsOn = targetIsOn
        self.targetValue = targetValue
    }
}
