//
//  AutomationCreate-ViewModel.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import Foundation
import SwiftData

extension AutomationCreateView {
    @Observable
    class ViewModel {
        var name: String = ""
        var triggerType: TriggerType = .manual
        var triggerValue: String = ""
        var triggerDate: Date = Date()
        var triggerDevice: Device? = nil
        var actionDrafts: [ActionDraft] = []

        var isEditing: Bool { editingAutomation != nil }
        private let editingAutomation: Automation?

        init(automation: Automation? = nil) {
            editingAutomation = automation
            if let automation {
                name = automation.name
                triggerType = automation.triggerType
                triggerValue = automation.triggerValue
                if automation.triggerType == .time && !automation.triggerValue.isEmpty {
                    let f = DateFormatter()
                    f.timeStyle = .short
                    f.dateStyle = .none
                    if let date = f.date(from: automation.triggerValue) { triggerDate = date }
                }
                for action in automation.actions {
                    actionDrafts.append(ActionDraft(
                        device: action.device,
                        targetIsOn: action.targetIsOn,
                        targetValue: action.targetValue
                    ))
                }
            }
        }

        func addActionDraft() {
            actionDrafts.append(ActionDraft())
        }

        func save(context: ModelContext) {
            let finalValue = resolvedTriggerValue
            if let automation = editingAutomation {
                automation.name = name.trimmingCharacters(in: .whitespaces)
                automation.triggerType = triggerType
                automation.triggerValue = finalValue
                automation.actions.forEach { context.delete($0) }
                automation.actions = []
                for draft in actionDrafts {
                    guard let device = draft.device else { continue }
                    let action = SceneAction(targetIsOn: draft.targetIsOn, targetValue: draft.targetValue)
                    action.device = device
                    context.insert(action)
                    automation.actions.append(action)
                }
            } else {
                let automation = Automation(
                    name: name.trimmingCharacters(in: .whitespaces),
                    triggerType: triggerType
                )
                automation.triggerValue = finalValue
                context.insert(automation)
                for draft in actionDrafts {
                    guard let device = draft.device else { continue }
                    let action = SceneAction(targetIsOn: draft.targetIsOn, targetValue: draft.targetValue)
                    action.device = device
                    context.insert(action)
                    automation.actions.append(action)
                }
            }
            try? context.save()
        }

        private var resolvedTriggerValue: String {
            switch triggerType {
            case .time:
                let f = DateFormatter()
                f.timeStyle = .short
                f.dateStyle = .none
                return f.string(from: triggerDate)
            case .deviceState:
                return triggerDevice?.name ?? ""
            default:
                return triggerValue
            }
        }
    }
}
