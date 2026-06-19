//
//  StatusBadge.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftUI

struct StatusBadge: View {
    let isOnline: Bool

    var body: some View {
        Text(isOnline ? "Online" : "Offline")
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .foregroundStyle(isOnline ? Color.statusOnline : Color.statusOffline)
            .background((isOnline ? Color.statusOnline : Color.statusOffline).opacity(0.15))
            .clipShape(Capsule())
    }
}

#Preview {
    HStack {
        StatusBadge(isOnline: true)
        StatusBadge(isOnline: false)
    }
    .padding()
    .background(Color.surfacePrimary)
}
