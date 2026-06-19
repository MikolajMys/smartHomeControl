//
//  HomeSceneRowView.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 17/06/2026.
//

import SwiftUI

struct HomeSceneRowView: View {
    let scenes: [SmartScene]
    let onRun: (SmartScene) -> Void
    @State private var navigateToScenes = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Scenes", onSeeAll: { navigateToScenes = true })

            if scenes.isEmpty {
                Text("No scenes yet. Tap See All to create one.")
                    .font(.subheadline)
                    .foregroundStyle(Color.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 12)
                    .padding()
                    .background(Color.surfaceCard)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(scenes) { scene in
                            SceneCard(scene: scene, onRun: { onRun(scene) })
                        }
                    }
                    .padding(.horizontal, 1)
                }
            }
        }
        .navigationDestination(isPresented: $navigateToScenes) {
            SmartScenesListView()
        }
    }
}

private struct SceneCard: View {
    let scene: SmartScene
    let onRun: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: scene.iconName)
                .font(.title2)
                .foregroundStyle(Color.accentBlue)
                .frame(width: 44, height: 44)
                .background(Color.accentBlue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(scene.name)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(Color.textPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 80)

            Button(action: onRun) {
                Text("Run")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.accentBlue)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(12)
        .frame(width: 100, height: 140)
        .background(Color.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
