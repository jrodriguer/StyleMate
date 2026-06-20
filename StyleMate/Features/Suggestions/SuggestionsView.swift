import SwiftUI

struct SuggestionsView: View {
    let suggestions: [StyleSuggestion]

    var body: some View {
        NavigationStack {
            Group {
                if suggestions.isEmpty {
                    ContentUnavailableView(
                        "No Looks Yet",
                        systemImage: "sparkles.rectangle.stack",
                        description: Text("Snap a garment and get style ideas to see them here.")
                    )
                } else {
                    VStack(spacing: 12) {
                        if let query = suggestions.first?.description, !query.isEmpty {
                            Text("Suggestions for: \(query)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .padding(.top, 8)
                        }

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(suggestions) { suggestion in
                                    SuggestionCard(suggestion: suggestion)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Your Looks")
        }
    }
}

struct SuggestionCard: View {
    let suggestion: StyleSuggestion
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(suggestion.baseColor)
                    .overlay {
                        VStack(spacing: 4) {
                            Text("Your")
                                .font(.caption2.bold())
                                .foregroundStyle(.white.opacity(0.7))
                            Image(systemName: "circle.fill")
                                .font(.title2)
                                .foregroundStyle(.white.opacity(0.3))
                        }
                    }

                RoundedRectangle(cornerRadius: 16)
                    .fill(suggestion.color)
                    .overlay {
                        VStack(spacing: 4) {
                            Text("Pair")
                                .font(.caption2.bold())
                                .foregroundStyle(.white.opacity(0.7))
                            Image(systemName: "circle.fill")
                                .font(.title2)
                                .foregroundStyle(.white.opacity(0.3))
                        }
                    }
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            VStack(alignment: .leading, spacing: 4) {
                Text(suggestion.title)
                    .font(.headline)
                Text(suggestion.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            .padding(.horizontal, 4)
        }
        .frame(width: 280)
    }
}

#Preview {
    SuggestionsView(
        suggestions: [
            StyleSuggestion(
                title: "Top 1",
                description: "t-shirt",
                color: .red,
                baseColor: .blue,
                garments: []
            ),
            StyleSuggestion(
                title: "Top 2",
                description: "t-shirt",
                color: .green,
                baseColor: .blue,
                garments: []
            )
        ]
    )
}
