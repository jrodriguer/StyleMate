import SwiftUI

struct SuggestionCard: View {
    let suggestion: StyleSuggestion

    private var garmentType: GarmentType? {
        suggestion.garments.first?.type
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            colorSwatch

            VStack(alignment: .leading, spacing: 8) {
                if let type = garmentType {
                    Text(type.rawValue)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(Color.appAccent)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.appAccentSubtle, in: RoundedRectangle(cornerRadius: 6))
                }

                Text(suggestion.title)
                    .font(.headline)

                if !suggestion.description.isEmpty {
                    Text(suggestion.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
            .padding(16)
        }
        .frame(width: 270)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.06), radius: 8, y: 4)
    }

    private var colorSwatch: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [suggestion.baseColor, suggestion.color],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(alignment: .leading, spacing: 2) {
                Label("You", systemImage: "circle.fill")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(suggestion.baseColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 6))

                Label("Pair", systemImage: "circle.fill")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(suggestion.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 6))
            }
            .padding(12)
        }
        .frame(height: 180)
    }
}

#Preview {
    HStack(spacing: 16) {
        SuggestionCard(
            suggestion: StyleSuggestion(
                title: "Casual Look",
                description: "t-shirt",
                color: .paletteOlive,
                baseColor: .paletteNavy,
                garments: [Garment(type: .top, color: "#2C3E50", description: "")]
            )
        )
        SuggestionCard(
            suggestion: StyleSuggestion(
                title: "Evening Look",
                description: "blazer",
                color: .paletteBurgundy,
                baseColor: .paletteSlate,
                garments: [Garment(type: .outerwear, color: "#6C7A89", description: "")]
            )
        )
    }
    .padding()
    .background(Color.appBackground)
}
