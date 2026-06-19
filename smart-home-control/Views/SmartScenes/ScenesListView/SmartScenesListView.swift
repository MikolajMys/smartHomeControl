//
//  SmartScenesListView.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftUI
import SwiftData

struct SmartScenesListView: View {
    @Query(sort: \SmartScene.name) private var scenes: [SmartScene]
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ViewModel()
    @State private var showCreateSheet = false
    @State private var editingScene: SmartScene? = nil

    var body: some View {
        List {
            ForEach(scenes) { scene in
                SceneRowView(scene: scene, onRun: { viewModel.executeScene(scene) })
                    .swipeActions(edge: .leading) {
                        Button { editingScene = scene } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.orange)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            viewModel.deleteScene(scene)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
        .overlay {
            if scenes.isEmpty {
                EmptyStateView(
                    iconName: "wand.and.stars",
                    title: "No Scenes",
                    message: "Tap + to create a scene that controls multiple devices at once."
                )
            }
        }
        .navigationTitle("Scenes")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { showCreateSheet = true } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showCreateSheet) {
            SmartSceneCreateView()
        }
        .sheet(item: $editingScene) { scene in
            SmartSceneCreateView(scene: scene)
        }
        .onAppear { viewModel.context = modelContext }
    }
}

private struct SceneRowView: View {
    let scene: SmartScene
    let onRun: () -> Void

    private var actionSummary: String {
        let total = scene.actions.count + scene.automationActions.count
        return "\(total) action\(total == 1 ? "" : "s")"
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: scene.iconName)
                .font(.title3)
                .foregroundStyle(Color.accentBlue)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(scene.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.textPrimary)
                Text(actionSummary)
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
            }

            Spacer()

            Button(action: onRun) {
                Text("Run")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.accentBlue)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        SmartScenesListView()
    }
    .modelContainer(.preview)
}
