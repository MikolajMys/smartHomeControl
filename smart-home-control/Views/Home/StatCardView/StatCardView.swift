//
//  StatCardView.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftUI

struct StatCardView: View {
    let label: String
    let value: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .textCase(.uppercase)
                .foregroundStyle(Color.textSecondary)
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(Color.textPrimary)
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(Color.textSecondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    StatCardView(label: "Temperature", value: "22.2°C", subtitle: "Average indoor")
        .padding()
        .background(Color.surfacePrimary)
}
