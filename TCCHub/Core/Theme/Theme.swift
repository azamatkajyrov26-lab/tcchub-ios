import SwiftUI

enum Theme {
    enum Color {
        static let primary      = SwiftUI.Color(hex: 0xC6A46D)
        static let primaryHover = SwiftUI.Color(hex: 0xA38450)
        static let primaryLight = SwiftUI.Color(hex: 0xD4B87E)
        static let navy         = SwiftUI.Color(hex: 0x1B2A4A)
        static let navyLight    = SwiftUI.Color(hex: 0x2D4A7A)
        static let surface      = SwiftUI.Color(hex: 0xFAFBFD)
        static let surfaceAlt   = SwiftUI.Color(hex: 0xF3F4F8)
        static let textPrimary  = SwiftUI.Color(hex: 0x1B2A4A)
        static let textMid      = SwiftUI.Color(hex: 0x3D5070)
        static let textLight    = SwiftUI.Color(hex: 0x7A8BA8)
        static let divider      = SwiftUI.Color(hex: 0x1B2A4A, alpha: 0.08)
    }

    enum Radius {
        static let card: CGFloat = 16
        static let pill: CGFloat = 30
    }

    enum Spacing {
        static let xs: CGFloat = 4
        static let s:  CGFloat = 8
        static let m:  CGFloat = 16
        static let l:  CGFloat = 24
        static let xl: CGFloat = 32
    }

    enum Font {
        static func regular(_ size: CGFloat) -> SwiftUI.Font {
            .custom("Montserrat-Regular", size: size)
        }
        static func medium(_ size: CGFloat) -> SwiftUI.Font {
            .custom("Montserrat-Medium", size: size)
        }
        static func semibold(_ size: CGFloat) -> SwiftUI.Font {
            .custom("Montserrat-SemiBold", size: size)
        }
        static func bold(_ size: CGFloat) -> SwiftUI.Font {
            .custom("Montserrat-Bold", size: size)
        }
    }
}
