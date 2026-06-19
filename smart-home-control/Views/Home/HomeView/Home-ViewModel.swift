//
//  Home-ViewModel.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import Foundation
import SwiftData

struct HomeSection: Codable, Identifiable, Equatable {
    let id: String
    var isVisible: Bool
    var displayName: String
}

extension HomeView {
    @Observable
    class ViewModel {
        var modelContext: ModelContext?
        var homeSections: [HomeSection]

        init() {
            self.homeSections = Self.loadSections()
        }

        // MARK: – Actions (need modelContext)

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
            try? modelContext?.save()
        }

        func toggleAutomation(_ automation: Automation) {
            automation.isEnabled.toggle()
            try? modelContext?.save()
        }

        // MARK: – Section ordering

        var visibleSections: [HomeSection] {
            homeSections.filter { $0.isVisible }
        }

        func saveSections() {
            if let data = try? JSONEncoder().encode(homeSections) {
                UserDefaults.standard.set(data, forKey: "homeSections")
            }
        }

        func resetSections() {
            homeSections = Self.defaultSections
            saveSections()
        }

        static func loadSections() -> [HomeSection] {
            guard let data = UserDefaults.standard.data(forKey: "homeSections"),
                  let saved = try? JSONDecoder().decode([HomeSection].self, from: data)
            else { return defaultSections }
            return saved
        }

        static let defaultSections: [HomeSection] = [
            HomeSection(id: "stats",       isVisible: true, displayName: "Statistics"),
            HomeSection(id: "devices",     isVisible: true, displayName: "Devices"),
            HomeSection(id: "energy",      isVisible: true, displayName: "Energy"),
            HomeSection(id: "scenes",      isVisible: true, displayName: "Scenes"),
            HomeSection(id: "automations", isVisible: true, displayName: "Automations"),
        ]
    }
}
