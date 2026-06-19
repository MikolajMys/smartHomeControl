//
//  smart_home_controlApp.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 13/06/2026.
//

import SwiftUI
import SwiftData

@main
struct smart_home_controlApp: App {
    let container = ModelContainerSetup.mainContainer

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .onAppear(perform: populateIfNeeded)
        }
        .modelContainer(container)
    }

    private func populateIfNeeded() {
        let context = container.mainContext
        let count = (try? context.fetchCount(FetchDescriptor<Device>())) ?? 0
        guard count == 0 else { return }
        try? SampleData.populate(context)
    }
}
