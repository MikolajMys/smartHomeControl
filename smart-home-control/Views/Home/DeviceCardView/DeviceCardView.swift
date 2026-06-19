//
//  DeviceCardView.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftUI

struct DeviceCardView: View {
    let device: Device

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Image(systemName: device.iconName)
                    .font(.title2)
                    .foregroundStyle(device.isOnline ? Color.accentBlue : Color.textSecondary)
                Spacer()
                DeviceToggle(
                    isOn: Binding(
                        get: { device.isOn },
                        set: { newValue in
                            device.isOn = newValue
                            device.updatedAt = Date()
                        }
                    ),
                    isDisabled: !device.isOnline
                )
            }

            Text(device.name)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.textPrimary)
                .lineLimit(1)

            HStack(spacing: 6) {
                StatusBadge(isOnline: device.isOnline)
                if let value = device.currentValue, let unit = device.unit {
                    Text(String(format: "%.1f%@", value, unit))
                        .font(.caption)
                        .foregroundStyle(Color.textSecondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    let device = Device(name: "Ceiling Light", type: .light)
    device.isOnline = true
    device.isOn = true
    device.currentValue = 75
    return DeviceCardView(device: device)
        .padding()
        .background(Color.surfacePrimary)
}
