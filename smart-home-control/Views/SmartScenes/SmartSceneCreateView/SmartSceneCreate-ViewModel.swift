//
//  SmartSceneCreate-ViewModel.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import Foundation
import SwiftData

// Shared by both SceneCreate and AutomationCreate
struct ActionDraft: Identifiable {
    var id = UUID()
    var device: Device? = nil
    var targetIsOn: Bool = true
    var targetValue: Double? = nil
}

struct AutomationActionDraft: Identifiable {
    var id = UUID()
    var automation: Automation? = nil
    var targetIsEnabled: Bool = true
}

extension SmartSceneCreateView {
    @Observable
    class ViewModel {
        var name: String = ""
        var selectedIcon: String = "sparkles"
        var actionDrafts: [ActionDraft] = []
        var automationActionDrafts: [AutomationActionDraft] = []

        var isEditing: Bool { editingScene != nil }
        private let editingScene: SmartScene?

        init(scene: SmartScene? = nil) {
            editingScene = scene
            if let scene {
                name = scene.name
                selectedIcon = scene.iconName
                for action in scene.actions {
                    actionDrafts.append(ActionDraft(
                        device: action.device,
                        targetIsOn: action.targetIsOn,
                        targetValue: action.targetValue
                    ))
                }
                for autoAction in scene.automationActions {
                    automationActionDrafts.append(AutomationActionDraft(
                        automation: autoAction.automation,
                        targetIsEnabled: autoAction.targetIsEnabled
                    ))
                }
            }
        }

        func addActionDraft() {
            actionDrafts.append(ActionDraft())
        }

        func addAutomationActionDraft() {
            automationActionDrafts.append(AutomationActionDraft())
        }

        func save(context: ModelContext) {
            if let scene = editingScene {
                scene.name = name.trimmingCharacters(in: .whitespaces)
                scene.iconName = selectedIcon
                scene.actions.forEach { context.delete($0) }
                scene.actions = []
                scene.automationActions.forEach { context.delete($0) }
                scene.automationActions = []
                appendActions(to: scene, context: context)
            } else {
                let scene = SmartScene(
                    name: name.trimmingCharacters(in: .whitespaces),
                    iconName: selectedIcon
                )
                context.insert(scene)
                appendActions(to: scene, context: context)
            }
            try? context.save()
        }

        private func appendActions(to scene: SmartScene, context: ModelContext) {
            for draft in actionDrafts {
                guard let device = draft.device else { continue }
                let action = SceneAction(targetIsOn: draft.targetIsOn, targetValue: draft.targetValue)
                action.device = device
                action.scene = scene
                context.insert(action)
            }
            for draft in automationActionDrafts {
                guard let automation = draft.automation else { continue }
                let autoAction = SceneAutomationAction(targetIsEnabled: draft.targetIsEnabled)
                autoAction.automation = automation
                autoAction.scene = scene
                context.insert(autoAction)
            }
        }
    }
}
