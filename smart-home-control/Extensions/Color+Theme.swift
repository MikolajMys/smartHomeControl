//
//  Color+Theme.swift
//  smart-home-control
//
//  Created by Mikołaj Myśliński on 15/06/2026.
//

import SwiftUI

extension Color {
    // #2563C4 light / #6EA8FE dark
    static let accentBlue = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0x6E / 255.0, green: 0xA8 / 255.0, blue: 0xFE / 255.0, alpha: 1)
            : UIColor(red: 0x25 / 255.0, green: 0x63 / 255.0, blue: 0xC4 / 255.0, alpha: 1)
    })

    // #F5F7FA light / #0F1319 dark
    static let surfacePrimary = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0x0F / 255.0, green: 0x13 / 255.0, blue: 0x19 / 255.0, alpha: 1)
            : UIColor(red: 0xF5 / 255.0, green: 0xF7 / 255.0, blue: 0xFA / 255.0, alpha: 1)
    })

    // #FFFFFF light / white 5% opacity dark
    static let surfaceCard = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(white: 1, alpha: 0.05)
            : UIColor(white: 1, alpha: 1)
    })

    // Near-black light / near-white dark
    static let textPrimary = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0xF9 / 255.0, green: 0xFA / 255.0, blue: 0xFB / 255.0, alpha: 1)
            : UIColor(red: 0x11 / 255.0, green: 0x18 / 255.0, blue: 0x27 / 255.0, alpha: 1)
    })

    // textPrimary at 0.4 opacity
    static let textSecondary = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0xF9 / 255.0, green: 0xFA / 255.0, blue: 0xFB / 255.0, alpha: 0.4)
            : UIColor(red: 0x11 / 255.0, green: 0x18 / 255.0, blue: 0x27 / 255.0, alpha: 0.4)
    })

    static let statusOnline = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0x34 / 255.0, green: 0xD3 / 255.0, blue: 0x99 / 255.0, alpha: 1)
            : UIColor(red: 0x10 / 255.0, green: 0xB9 / 255.0, blue: 0x81 / 255.0, alpha: 1)
    })

    static let statusOffline = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(white: 1, alpha: 0.3)
            : UIColor(white: 0, alpha: 0.3)
    })
}
