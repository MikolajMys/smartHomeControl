//
//  Date+Formatting.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import Foundation

extension Date {
    var timeAgo: String {
        let interval = Date().timeIntervalSince(self)
        switch interval {
        case ..<60:
            return "just now"
        case 60..<3600:
            let mins = Int(interval / 60)
            return "\(mins) min ago"
        case 3600..<86400:
            let hours = Int(interval / 3600)
            return "\(hours)h ago"
        case 86400..<172800:
            return "yesterday"
        default:
            let days = Int(interval / 86400)
            return "\(days) days ago"
        }
    }

    var shortTime: String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: self)
    }

    var dayString: String {
        let f = DateFormatter()
        f.dateFormat = "EEE"
        return f.string(from: self)
    }
}
