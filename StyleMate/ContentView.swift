import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            CameraView()
                .tabItem {
                    Label("Snap", systemImage: "camera.fill")
                }
                .tag(0)

            SuggestionsView()
                .tabItem {
                    Label("Looks", systemImage: "sparkles.rectangle.stack")
                }
                .tag(1)
        }
        .tint(.pink)
    }
}

#Preview {
    ContentView()
}
