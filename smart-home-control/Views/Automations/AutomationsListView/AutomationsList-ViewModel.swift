//
//  AutomationsList-ViewModel.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import Foundation
import SwiftData

extension AutomationsListView {
    @Observable
    class ViewModel {
        var context: ModelContext?

        func deleteAutomation(_ automation: Automation) {
            context?.delete(automation)
            try? context?.save()
        }

        func toggleEnabled(_ automation: Automation) {
            automation.isEnabled.toggle()
            try? context?.save()
        }
    }
}
