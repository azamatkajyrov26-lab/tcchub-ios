import SwiftUI
import UIKit

// MARK: - Adaptive color helper

extension Color {
    /// Builds a color that automatically switches between light and dark mode.
    init(light: UInt32, dark: UInt32, lightAlpha: Double = 1, darkAlpha: Double = 1) {
        let ui = UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(hex: dark, alpha: darkAlpha)
                : UIColor(hex: light, alpha: lightAlpha)
        }
        self = Color(ui)
    }
}

private extension UIColor {
    convenience init(hex: UInt32, alpha: Double = 1) {
        let r = CGFloat((hex >> 16) & 0xFF) / 255
        let g = CGFloat((hex >> 8) & 0xFF) / 255
        let b = CGFloat(hex & 0xFF) / 255
        self.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
}

// MARK: - Design tokens (generated from Design/tokens/*.json)

enum Theme {
    enum Color {
        // Brand
        static let primary       = SwiftUI.Color(light: 0xC6A46D, dark: 0xD4B87E)
        static let primaryHover  = SwiftUI.Color(light: 0xA38450, dark: 0xE0C68F)
        static let primaryMuted  = SwiftUI.Color(light: 0xF5EEDF, dark: 0x3A2F1E)
        static let navy          = SwiftUI.Color(light: 0x1B2A4A, dark: 0xE6ECF5)
        static let navyLight     = SwiftUI.Color(light: 0x2D4A7A, dark: 0xB8C4D8)

        // Surface
        static let background    = SwiftUI.Color(light: 0xFAFBFD, dark: 0x0E1320)
        static let surface       = background  // alias for legacy code
        static let card          = SwiftUI.Color(light: 0xFFFFFF, dark: 0x1A2133)
        static let elevated      = SwiftUI.Color(light: 0xFFFFFF, dark: 0x242C42)
        static let surfaceAlt    = SwiftUI.Color(light: 0xF3F4F8, dark: 0x151B2A)

        // Text
        static let textPrimary   = SwiftUI.Color(light: 0x1B2A4A, dark: 0xF5F7FB)
        static let textMid       = SwiftUI.Color(light: 0x3D5070, dark: 0xB8C4D8)
        static let textLight     = SwiftUI.Color(light: 0x7A8BA8, dark: 0x7A8BA8)
        static let onPrimary     = SwiftUI.Color(light: 0xFFFFFF, dark: 0x0E1320)

        // Border
        static let divider       = SwiftUI.Color(light: 0x1B2A4A, dark: 0xFFFFFF, lightAlpha: 0.08, darkAlpha: 0.08)
        static let dividerStrong = SwiftUI.Color(light: 0x1B2A4A, dark: 0xFFFFFF, lightAlpha: 0.16, darkAlpha: 0.16)

        // Semantic
        static let success       = SwiftUI.Color(light: 0x2E8B57, dark: 0x4CAF82)
        static let warning       = SwiftUI.Color(light: 0xE0A020, dark: 0xF2B73A)
        static let error         = SwiftUI.Color(light: 0xD9534F, dark: 0xFF6B6B)
        static let info          = SwiftUI.Color(light: 0x4A90E2, dark: 0x6AA8EE)

        // Gradient stops
        static let heroGradient  = LinearGradient(
            colors: [SwiftUI.Color(hex: 0x1B2A4A), SwiftUI.Color(hex: 0xC6A46D)],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
    }

    enum Radius {
        static let none: CGFloat = 0
        static let sm:   CGFloat = 8
        static let md:   CGFloat = 12
        static let card: CGFloat = 16
        static let lg:   CGFloat = 20
        static let pill: CGFloat = 30
    }

    enum Spacing {
        static let xs:   CGFloat = 4
        static let s:    CGFloat = 8
        static let m:    CGFloat = 16
        static let l:    CGFloat = 24
        static let xl:   CGFloat = 32
        static let xxl:  CGFloat = 48
        static let xxxl: CGFloat = 64
    }

    enum Font {
        // Falls back to system if Montserrat isn't bundled.
        static func regular(_ size: CGFloat) -> SwiftUI.Font  { .custom("Montserrat-Regular",  size: size) }
        static func medium(_ size: CGFloat)  -> SwiftUI.Font  { .custom("Montserrat-Medium",   size: size) }
        static func semibold(_ size: CGFloat)-> SwiftUI.Font  { .custom("Montserrat-SemiBold", size: size) }
        static func bold(_ size: CGFloat)    -> SwiftUI.Font  { .custom("Montserrat-Bold",     size: size) }
        static func black(_ size: CGFloat)   -> SwiftUI.Font  { .custom("Montserrat-Black",    size: size) }

        static let displayLarge  = bold(34)
        static let displayMedium = bold(28)
        static let title         = bold(22)
        static let headline      = semibold(17)
        static let body          = regular(15)
        static let bodyEmphasis  = medium(15)
        static let callout       = regular(14)
        static let caption       = regular(12)
    }
}

