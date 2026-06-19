//
//  EmptyStateView.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftUI

struct EmptyStateView: View {
    let iconName: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: iconName)
                .font(.system(size: 52))
                .foregroundStyle(Color.textSecondary)
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(Color.textPrimary)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyStateView(
        iconName: "lightbulb.slash",
        title: "No Devices",
        message: "Tap + to add your first device."
    )
    .background(Color.surfacePrimary)
}
