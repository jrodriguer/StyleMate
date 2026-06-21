import SwiftUI

extension Color {
    static let appBackground = Color(hex: "F2F2F7") ?? Color(.systemGray6)
    static let appSurface = Color.white
    static let appAccent = Color(hex: "2D3436") ?? Color(.darkGray)
    static let appAccentSubtle = Color(hex: "EDF2F7") ?? Color(.systemGray6)
    static let appBorder = Color(hex: "D1D8E0") ?? Color(.separator)
    static let appTextSecondary = Color(hex: "718096") ?? Color.secondary
    static let appShadow = Color.black.opacity(0.07)
    static let appError = Color(hex: "E74C3C") ?? Color.red

    static let paletteNavy = Color(hex: "2C3E50") ?? Color.blue
    static let paletteOlive = Color(hex: "7D8E6B") ?? Color.green
    static let paletteSteel = Color(hex: "5D6D7E") ?? Color.gray
    static let paletteSlate = Color(hex: "6C7A89") ?? Color.gray
    static let paletteBurgundy = Color(hex: "7B3F4F") ?? Color.purple
}
