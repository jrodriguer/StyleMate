import SwiftUI

struct ContentView: View {
    @State private var suggestions: [StyleSuggestion] = []
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            CameraView(suggestions: $suggestions, selectedTab: $selectedTab)
                .tabItem {
                    Label("Snap", systemImage: "camera.viewfinder")
                }
                .tag(0)

            SuggestionsView(suggestions: suggestions)
                .tabItem {
                    Label("Looks", systemImage: "sparkles.rectangle.stack")
                }
                .tag(1)
        }
    }
}

#Preview {
    ContentView()
}
