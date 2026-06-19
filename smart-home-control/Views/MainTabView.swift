//
//  MainTabView.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                NavigationStack {
                    HomeView()
                }
            }
            Tab("Rooms", systemImage: "square.grid.2x2") {
                NavigationStack {
                    RoomsListView()
                }
            }
            Tab("Scenes", systemImage: "wand.and.stars") {
                NavigationStack {
                    SmartScenesListView()
                }
            }
            Tab("Auto", systemImage: "bolt.fill") {
                NavigationStack {
                    AutomationsListView()
                }
            }
            Tab("Profile", systemImage: "person.fill") {
                NavigationStack {
                    ProfileView()
                }
            }
        }
        .tint(Color.accentBlue)
    }
}

#Preview {
    MainTabView()
        .modelContainer(.preview)
}
