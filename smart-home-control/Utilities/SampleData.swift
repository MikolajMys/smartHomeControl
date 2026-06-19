//
//  SampleData.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import Foundation
import SwiftData

struct SampleData {
    static func populate(_ context: ModelContext) throws {
        // Rooms
        let livingRoom = Room(name: "Living Room", iconName: "sofa", sortOrder: 0)
        let kitchen    = Room(name: "Kitchen",     iconName: "refrigerator", sortOrder: 1)
        let bedroom    = Room(name: "Bedroom",     iconName: "bed.double",   sortOrder: 2)
        context.insert(livingRoom)
        context.insert(kitchen)
        context.insert(bedroom)

        // Devices — Living Room
        let ceilingLight = Device(name: "Ceiling Light", type: .light)
        ceilingLight.isOnline = true
        ceilingLight.isOn = true
        ceilingLight.currentValue = 75
        ceilingLight.isFavorite = true
        ceilingLight.room = livingRoom

        let acUnit = Device(name: "AC Unit", type: .thermostat)
        acUnit.isOnline = true
        acUnit.isOn = true
        acUnit.currentValue = 22
        acUnit.isFavorite = true
        acUnit.room = livingRoom

        // Devices — Kitchen
        let smartPlug = Device(name: "Smart Plug", type: .plug)
        smartPlug.isOnline = false
        smartPlug.isOn = false
        smartPlug.room = kitchen

        let tempSensor = Device(name: "Temp Sensor", type: .sensor)
        tempSensor.isOnline = true
        tempSensor.isOn = true
        tempSensor.currentValue = 22.4
        tempSensor.unit = "°C"
        tempSensor.room = kitchen

        // Devices — Bedroom
        let doorLock = Device(name: "Door Lock", type: .lock)
        doorLock.isOnline = true
        doorLock.isOn = true
        doorLock.room = bedroom

        let securityCam = Device(name: "Security Cam", type: .camera)
        securityCam.isOnline = true
        securityCam.isOn = true
        securityCam.room = bedroom

        [ceilingLight, acUnit, smartPlug, tempSensor, doorLock, securityCam].forEach {
            context.insert($0)
        }

        // Energy readings — 12 hourly slots aligned to full hours (endHour-12h … endHour-1h)
        let now = Date()
        let cal = Calendar.current
        let endHour = cal.date(from: cal.dateComponents([.year, .month, .day, .hour], from: now))!
        for i in 0..<12 {
            let reading = EnergyReading(
                timestamp: endHour.addingTimeInterval(Double(i - 12) * 3600),
                valueKWh: Double.random(in: 0.5...2.5)
            )
            context.insert(reading)
        }

        // Scenes
        let morningScene = SmartScene(name: "Good Morning", iconName: "sun.max.fill")
        let morningOn  = SceneAction(targetIsOn: true,  targetValue: 100); morningOn.device = ceilingLight;  morningOn.scene = morningScene
        let morningAC  = SceneAction(targetIsOn: true,  targetValue: 21);  morningAC.device = acUnit;        morningAC.scene = morningScene

        let nightScene = SmartScene(name: "Good Night", iconName: "moon.stars.fill")
        let nightOff   = SceneAction(targetIsOn: false);                    nightOff.device = ceilingLight;  nightOff.scene = nightScene
        let nightLock  = SceneAction(targetIsOn: true);                     nightLock.device = doorLock;     nightLock.scene = nightScene

        let awayScene  = SmartScene(name: "Away Mode",  iconName: "figure.walk")
        let awayLight  = SceneAction(targetIsOn: false);                    awayLight.device = ceilingLight; awayLight.scene = awayScene
        let awayAC     = SceneAction(targetIsOn: false);                    awayAC.device = acUnit;          awayAC.scene = awayScene

        [morningScene, nightScene, awayScene].forEach { context.insert($0) }
        [morningOn, morningAC, nightOff, nightLock, awayLight, awayAC].forEach { context.insert($0) }

        // Automations
        let morningAuto = Automation(name: "Wake Up Lights", triggerType: .time)
        morningAuto.triggerValue = "07:00"
        morningAuto.isEnabled = true

        let tempAuto = Automation(name: "Cool Down", triggerType: .temperature)
        tempAuto.triggerValue = "26"
        tempAuto.isEnabled = true

        let nightAuto = Automation(name: "Bedtime Lock", triggerType: .time)
        nightAuto.triggerValue = "23:00"
        nightAuto.isEnabled = false

        [morningAuto, tempAuto, nightAuto].forEach { context.insert($0) }

        // Scene automation actions
        // "Good Night" enables "Bedtime Lock" + disables "Wake Up Lights"
        let nightEnableBedtime = SceneAutomationAction(targetIsEnabled: true)
        nightEnableBedtime.automation = nightAuto
        nightEnableBedtime.scene = nightScene

        let nightDisableMorning = SceneAutomationAction(targetIsEnabled: false)
        nightDisableMorning.automation = morningAuto
        nightDisableMorning.scene = nightScene

        // "Good Morning" re-enables "Wake Up Lights"
        let morningEnableWakeup = SceneAutomationAction(targetIsEnabled: true)
        morningEnableWakeup.automation = morningAuto
        morningEnableWakeup.scene = morningScene

        [nightEnableBedtime, nightDisableMorning, morningEnableWakeup].forEach { context.insert($0) }

        try context.save()
    }
}
