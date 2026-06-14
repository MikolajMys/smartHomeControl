//
//  Item.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 13/06/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
