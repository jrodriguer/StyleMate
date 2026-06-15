import SwiftUI

struct SuggestionsView: View {
    // TODO: Replace with actual data from API
    @State private var suggestions: [StyleSuggestion] = []
    @State private var isLoading = false

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
            .navigationTitle("Your Looks")
        }
    }
}

struct SuggestionCard: View {
    let suggestion: StyleSuggestion

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Placeholder image area
            RoundedRectangle(cornerRadius: 16)
                .fill(suggestion.color.gradient)
                .frame(width: 240, height: 320)
                .overlay {
                    VStack(spacing: 8) {
                        Image(systemName: "tshirt.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.white.opacity(0.8))
                        Text(suggestion.title)
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                    }
                }

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
        .frame(width: 240)
    }
}

#Preview {
    SuggestionsView()
}
