//
//  SmartScenesList-ViewModel.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import Foundation
import SwiftData

extension SmartScenesListView {
    @Observable
    class ViewModel {
        var context: ModelContext?

        func executeScene(_ scene: SmartScene) {
            for action in scene.actions {
                guard let device = action.device else { continue }
                device.isOn = action.targetIsOn
                if let value = action.targetValue { device.currentValue = value }
                device.updatedAt = Date()
            }
            for autoAction in scene.automationActions {
                guard let automation = autoAction.automation else { continue }
                automation.isEnabled = autoAction.targetIsEnabled
            }
            try? context?.save()
        }

        func deleteScene(_ scene: SmartScene) {
            context?.delete(scene)
            try? context?.save()
        }
    }
}
