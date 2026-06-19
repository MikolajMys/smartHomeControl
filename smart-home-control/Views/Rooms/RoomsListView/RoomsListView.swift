//
//  RoomsListView.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftUI
import SwiftData

struct RoomsListView: View {
    @Query(sort: \Room.sortOrder) private var rooms: [Room]
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ViewModel()
    @State private var showCreateSheet = false

    var body: some View {
        List {
            ForEach(rooms) { room in
                NavigationLink(destination: RoomDetailsView(room: room)) {
                    RoomRowView(room: room)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        viewModel.deleteRoom(room)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .overlay {
            if rooms.isEmpty {
                EmptyStateView(
                    iconName: "square.split.2x2",
                    title: "No Rooms",
                    message: "Tap + to create your first room."
                )
            }
        }
        .navigationTitle("Rooms")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showCreateSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showCreateSheet) {
            RoomCreateView()
        }
        .onAppear {
            viewModel.context = modelContext
        }
    }
}

private struct RoomRowView: View {
    let room: Room

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: room.iconName)
                .font(.title3)
                .foregroundStyle(Color.accentBlue)
                .frame(width: 32)

            Text(room.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(Color.textPrimary)

            Spacer()

            Text("\(room.devices.count)")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Color.accentBlue)
                .clipShape(Capsule())
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        RoomsListView()
    }
    .modelContainer(.preview)
}
