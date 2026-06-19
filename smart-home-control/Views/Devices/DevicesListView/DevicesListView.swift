//
//  DevicesListView.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftUI
import SwiftData

struct DevicesListView: View {
    @Query(sort: \Device.name) private var devices: [Device]
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ViewModel()
    @State private var showCreateSheet = false

    private var filteredDevices: [Device] {
        guard !viewModel.searchText.isEmpty else { return devices }
        return devices.filter { $0.name.localizedCaseInsensitiveContains(viewModel.searchText) }
    }

    var body: some View {
        @Bindable var vm = viewModel
        List {
            ForEach(filteredDevices) { device in
                NavigationLink(destination: DeviceDetailsView(device: device)) {
                    DeviceRowView(device: device)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        viewModel.deleteDevice(device)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .swipeActions(edge: .leading) {
                    Button {
                        viewModel.toggleFavorite(device)
                    } label: {
                        Label(
                            device.isFavorite ? "Unfavorite" : "Favorite",
                            systemImage: device.isFavorite ? "star.slash" : "star"
                        )
                    }
                    .tint(.yellow)
                }
            }
        }
        .searchable(text: $vm.searchText, prompt: "Search devices")
        .overlay {
            if filteredDevices.isEmpty {
                EmptyStateView(
                    iconName: "lightbulb.slash",
                    title: viewModel.searchText.isEmpty ? "No Devices" : "No Results",
                    message: viewModel.searchText.isEmpty
                        ? "Tap + to add your first device."
                        : "No devices match \"\(viewModel.searchText)\"."
                )
            }
        }
        .navigationTitle("Devices")
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
            DeviceCreateView()
        }
        .onAppear {
            viewModel.context = modelContext
        }
    }
}

private struct DeviceRowView: View {
    let device: Device

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: device.iconName)
                .font(.title3)
                .foregroundStyle(device.isOnline ? Color.accentBlue : Color.textSecondary)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(device.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.textPrimary)
                if let roomName = device.room?.name {
                    Text(roomName)
                        .font(.caption)
                        .foregroundStyle(Color.textSecondary)
                }
            }

            Spacer()

            StatusBadge(isOnline: device.isOnline)

            if device.isFavorite {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundStyle(.yellow)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        DevicesListView()
    }
    .modelContainer(.preview)
}
