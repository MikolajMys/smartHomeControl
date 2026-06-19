//
//  PreviewHelpers.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftData

extension ModelContainer {
    static var preview: ModelContainer {
        let container = ModelContainerSetup.previewContainer
        let context = ModelContext(container)
        try? SampleData.populate(context)
        return container
    }
}
