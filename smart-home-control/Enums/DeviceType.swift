//
//  DeviceType.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import Foundation

enum DeviceType: String, Codable, CaseIterable {
    case light
    case thermostat
    case lock
    case plug
    case sensor
    case camera
    case blinds
    case speaker

    var displayName: String {
        switch self {
        case .light:      return "Light"
        case .thermostat: return "Thermostat"
        case .lock:       return "Lock"
        case .plug:       return "Smart Plug"
        case .sensor:     return "Sensor"
        case .camera:     return "Camera"
        case .blinds:     return "Blinds"
        case .speaker:    return "Speaker"
        }
    }

    var defaultIconName: String {
        switch self {
        case .light:      return "lightbulb.fill"
        case .thermostat: return "thermometer.medium"
        case .lock:       return "lock.fill"
        case .plug:       return "powerplug.fill"
        case .sensor:     return "sensor.fill"
        case .camera:     return "camera.fill"
        case .blinds:     return "blinds.horizontal.closed"
        case .speaker:    return "hifispeaker.fill"
        }
    }

    var defaultUnit: String? {
        switch self {
        case .thermostat: return "°C"
        case .blinds:     return "%"
        default:          return nil
        }
    }
}
