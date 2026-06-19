//
//  RoomDetailsView.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftUI
import SwiftData

struct RoomDetailsView: View {
    let room: Room
    @State private var showEditSheet = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                RoomHeaderCard(room: room)

                if room.devices.isEmpty {
                    EmptyRoomView()
                } else {
                    DeviceCardGrid(devices: room.devices.sorted { $0.name < $1.name })
                }
            }
            .padding()
        }
        .background(Color.surfacePrimary)
        .navigationTitle(room.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") { showEditSheet = true }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            RoomCreateView(room: room)
        }
    }
}

private struct RoomHeaderCard: View {
    let room: Room

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: room.iconName)
                .font(.system(size: 48))
                .foregroundStyle(Color.accentBlue)
            Text(room.name)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(Color.textPrimary)
            Text("\(room.devices.count) device\(room.devices.count == 1 ? "" : "s")")
                .font(.subheadline)
                .foregroundStyle(Color.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

private struct EmptyRoomView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "square.dashed")
                .font(.largeTitle)
                .foregroundStyle(Color.textSecondary)
            Text("No devices in this room")
                .font(.subheadline)
                .foregroundStyle(Color.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

#Preview {
    let container = ModelContainerSetup.previewContainer
    try? SampleData.populate(container.mainContext)
    let rooms = try? container.mainContext.fetch(FetchDescriptor<Room>())
    return NavigationStack {
        RoomDetailsView(room: rooms!.first!)
    }
    .modelContainer(container)
}
