//
//  DeviceCardGrid.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftUI

struct DeviceCardGrid: View {
    let devices: [Device]

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(devices) { device in
                DeviceCardView(device: device)
            }
        }
    }
}
