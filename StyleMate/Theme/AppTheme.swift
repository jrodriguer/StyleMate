import SwiftUI

// MARK: - Dynamic Color Helper

extension Color {
    /// Creates a color that adapts to light and dark mode.
    static func dynamic(light: String, dark: String) -> Color {
        Color(uiColor: UIColor { traits in
            if traits.userInterfaceStyle == .dark {
                return UIColor(Color(hex: dark) ?? Color(.systemGray))
            } else {
                return UIColor(Color(hex: light) ?? Color(.systemGray))
            }
        })
    }

    /// Creates a color with explicit light/dark UIColor values.
    static func dynamic(light: Color, dark: Color) -> Color {
        Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
        })
    }
}

// MARK: - Semantic App Colors

extension Color {
    /// Page background — light gray in light mode, pure black in dark mode.
    static let appBackground = Color.dynamic(light: "F2F2F7", dark: "000000")

    /// Elevated surfaces (cards, text fields) — white in light mode, dark gray in dark mode.
    static let appSurface = Color.dynamic(light: "FFFFFF", dark: "1C1C1E")

    /// Primary accent — dark charcoal in light mode, near-white in dark mode.
    static let appAccent = Color.dynamic(light: "2D3436", dark: "F5F5F7")

    /// Text color for content placed on top of `appAccent` backgrounds.
    static let appAccentContrast = Color.dynamic(light: "FFFFFF", dark: "1C1C1E")

    /// Subtle accent background (pills, badges) — light tint in light mode, elevated dark in dark mode.
    static let appAccentSubtle = Color.dynamic(light: "EDF2F7", dark: "2C2C2E")

    /// Borders and dividers.
    static let appBorder = Color.dynamic(light: "D1D8E0", dark: "38383A")

    /// Secondary text color.
    static let appTextSecondary = Color.dynamic(light: "718096", dark: "8E8E93")

    /// Shadow color — subtle in light mode, stronger in dark mode for visibility.
    static let appShadow = Color.dynamic(
        light: Color.black.opacity(0.07),
        dark: Color.black.opacity(0.35)
    )

    /// Error state color — slightly brighter red in dark mode for legibility.
    static let appError = Color.dynamic(light: "E74C3C", dark: "FF453A")
}

// MARK: - Palette Colors (static, used for garment swatches)

extension Color {
    static let paletteNavy = Color(hex: "2C3E50") ?? Color.blue
    static let paletteOlive = Color(hex: "7D8E6B") ?? Color.green
    static let paletteSteel = Color(hex: "5D6D7E") ?? Color.gray
    static let paletteSlate = Color(hex: "6C7A89") ?? Color.gray
    static let paletteBurgundy = Color(hex: "7B3F4F") ?? Color.purple
}
