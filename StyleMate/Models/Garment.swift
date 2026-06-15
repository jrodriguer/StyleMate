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
    let garments: [Garment]
}

struct StyleQuery: Codable {
    let garmentDescription: String
    let styleGoal: String
    let count: Int
}
