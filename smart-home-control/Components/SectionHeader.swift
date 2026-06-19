//
//  SectionHeader.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    var onSeeAll: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.textPrimary)
            Spacer()
            if let onSeeAll {
                Button("See All", action: onSeeAll)
                    .font(.subheadline)
                    .foregroundStyle(Color.accentBlue)
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        SectionHeader(title: "Devices")
        SectionHeader(title: "Rooms", onSeeAll: {})
    }
    .padding()
    .background(Color.surfacePrimary)
}
