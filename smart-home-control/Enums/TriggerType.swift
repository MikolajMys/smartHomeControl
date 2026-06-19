//
//  TriggerType.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import Foundation

enum TriggerType: String, Codable {
    case time
    case temperature
    case humidity
    case deviceState
    case manual
}
