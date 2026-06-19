//
//  HomeSectionEditorView.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 17/06/2026.
//

import SwiftUI

struct HomeSectionEditorView: View {
    @Bindable var viewModel: HomeView.ViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach($viewModel.homeSections) { $section in
                        HStack(spacing: 12) {
                            Toggle("", isOn: $section.isVisible)
                                .labelsHidden()
                                .tint(Color.accentBlue)
                            Text(section.displayName)
                                .foregroundStyle(Color.textPrimary)
                        }
                    }
                    .onMove { viewModel.homeSections.move(fromOffsets: $0, toOffset: $1) }
                } header: {
                    Text("Drag to reorder, toggle to show/hide")
                }

                Section {
                    Button("Reset to Default") {
                        viewModel.resetSections()
                    }
                    .foregroundStyle(Color.accentBlue)
                }
            }
            .environment(\.editMode, .constant(.active))
            .navigationTitle("Edit Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        viewModel.saveSections()
                        dismiss()
                    }
                }
            }
        }
    }
}
