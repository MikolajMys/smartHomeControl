//
//  ModelContainerSetup.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftData

struct ModelContainerSetup {
    static var mainContainer: ModelContainer {
        let schema = Schema([
            Device.self,
            Room.self,
            SmartScene.self,
            SceneAction.self,
            SceneAutomationAction.self,
            Automation.self,
            EnergyReading.self
        ])
        do {
            return try ModelContainer(for: schema)
        } catch {
            fatalError("Failed to create main ModelContainer: \(error)")
        }
    }

    static var previewContainer: ModelContainer {
        let schema = Schema([
            Device.self,
            Room.self,
            SmartScene.self,
            SceneAction.self,
            SceneAutomationAction.self,
            Automation.self,
            EnergyReading.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create preview ModelContainer: \(error)")
        }
    }
}
