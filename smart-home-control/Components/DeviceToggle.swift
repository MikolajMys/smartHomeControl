//
//  DeviceToggle.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftUI

struct DeviceToggle: View {
    @Binding var isOn: Bool
    let isDisabled: Bool

    var body: some View {
        Toggle("", isOn: $isOn)
            .labelsHidden()
            .toggleStyle(.switch)
            .tint(Color.accentBlue)
            .disabled(isDisabled)
    }
}

#Preview {
    @Previewable @State var on = true
    HStack(spacing: 20) {
        DeviceToggle(isOn: $on, isDisabled: false)
        DeviceToggle(isOn: .constant(false), isDisabled: true)
    }
    .padding()
    .background(Color.surfacePrimary)
}
