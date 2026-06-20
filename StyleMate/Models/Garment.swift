import SwiftUI

struct Garment: Identifiable, Codable {
    let id: UUID
    var type: GarmentType
    var color: String
    var description: String
    var imageData: Data?

    init(type: GarmentType, color: String, description: String = "", imageData: Data? = nil) {
        self.id = UUID()
        self.type = type
        self.color = color
        self.description = description
        self.imageData = imageData
    }
}

enum GarmentType: String, CaseIterable, Codable {
    case top = "Top"
    case bottom = "Bottom"
    case footwear = "Footwear"
    case outerwear = "Outerwear"
    case accessory = "Accessory"
    case fullOutfit = "Full Outfit"
}

struct StyleSuggestion: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let color: Color
    let baseColor: Color
    let garments: [Garment]
}

extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        guard Scanner(string: hex).scanHexInt64(&int) else { return nil }
        let r, g, b, a: UInt64
        switch hex.count {
        case 3:
            (r, g, b, a) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17, 255)
        case 6:
            (r, g, b, a) = (int >> 16, int >> 8 & 0xFF, int & 0xFF, 255)
        case 8:
            (r, g, b, a) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension GarmentType {
    static func from(query: String) -> GarmentType? {
        let q = query.lowercased()
        let topKeywords = ["camiseta", "camisa", "blusa", "top", "shirt", "t-shirt", "tshirt", "blouse", "polera", "remera"]
        let bottomKeywords = ["pantalon", "pantalón", "pantalones", "jeans", "vaqueros", "pants", "trouser", "trousers", "bermuda", "shorts", "pantaloneta"]
        let footwearKeywords = ["zapato", "zapatos", "sneakers", "shoes", "footwear", "calzado", "boots", "botas", "zapatilla", "zapatillas"]
        let outerwearKeywords = ["chaqueta", "jacket", "abrigo", "coat", "outerwear", "sueter", "suéter", "sweater", "sudadera", "hoodie", "chamarra", "cazadora"]
        let accessoryKeywords = ["accesorio", "accessory", "bolso", "bag", "cinturon", "cinturón", "belt", "sombrero", "hat", "reloj", "watch", "gafas", "glasses", "corbata", "tie"]

        if topKeywords.contains(where: { q.contains($0) }) { return .top }
        if bottomKeywords.contains(where: { q.contains($0) }) { return .bottom }
        if footwearKeywords.contains(where: { q.contains($0) }) { return .footwear }
        if outerwearKeywords.contains(where: { q.contains($0) }) { return .outerwear }
        if accessoryKeywords.contains(where: { q.contains($0) }) { return .accessory }
        return nil
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
