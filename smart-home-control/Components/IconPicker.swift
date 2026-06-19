//
//  IconPicker.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftUI

struct IconPicker: View {
    @Binding var selection: String

    private let icons = [
        "house", "bed.double", "fork.knife", "sofa",
        "bathtub", "car", "tv", "desktopcomputer",
        "leaf", "dumbbell", "book", "music.note"
    ]

    private let columns = Array(repeating: GridItem(.flexible()), count: 6)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(icons, id: \.self) { icon in
                Button {
                    selection = icon
                } label: {
                    Image(systemName: icon)
                        .font(.title2)
                        .frame(width: 44, height: 44)
                        .background(selection == icon ? Color.accentBlue : Color.surfaceCard)
                        .foregroundStyle(selection == icon ? .white : Color.textPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    @Previewable @State var selection = "house"
    IconPicker(selection: $selection)
        .padding()
        .background(Color.surfacePrimary)
}
