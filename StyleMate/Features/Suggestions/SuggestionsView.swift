import SwiftUI

struct SuggestionsView: View {
    let suggestions: [StyleSuggestion]

    var body: some View {
        NavigationStack {
            Group {
                if suggestions.isEmpty {
                    emptyState
                } else {
                    content
                }
            }
            .background(Color.appBackground)
            .navigationTitle("Your Looks")
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "camera.viewfinder")
                .font(.system(size: 56, weight: .thin))
                .foregroundStyle(Color.appAccent)

            Text("No Looks Yet")
                .font(.title2.weight(.semibold))

            Text("Snap a garment and get style ideas\nto see them here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let query = suggestions.first?.description, !query.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "quote.opening")
                        .foregroundStyle(.tertiary)
                    Text(query)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(suggestions.enumerated()), id: \.element.id) { index, suggestion in
                        SuggestionCard(suggestion: suggestion)
                            .transition(
                                .asymmetric(
                                    insertion: .opacity.combined(with: .scale(scale: 0.9).combined(with: .move(edge: .trailing))),
                                    removal: .opacity
                                )
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 4)
            }
        }
    }
}

#Preview {
    SuggestionsView(
        suggestions: [
            StyleSuggestion(
                title: "Weekend Look",
                description: "sneakers",
                color: .paletteOlive,
                baseColor: .paletteNavy,
                garments: [Garment(type: .footwear, color: "#2C3E50", description: "")]
            ),
            StyleSuggestion(
                title: "Evening Look",
                description: "blazer",
                color: .paletteBurgundy,
                baseColor: .paletteSteel,
                garments: [Garment(type: .outerwear, color: "#5D6D7E", description: "")]
            ),
            StyleSuggestion(
                title: "Casual Look",
                description: "t-shirt",
                color: .paletteSlate,
                baseColor: .paletteOlive,
                garments: [Garment(type: .top, color: "#7D8E6B", description: "")]
            )
        ]
    )
}
