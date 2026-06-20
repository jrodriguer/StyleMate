import SwiftUI

struct CameraView: View {
    @Binding var suggestions: [StyleSuggestion]
    @Binding var selectedTab: Int
    @State private var showCamera = false
    @State private var capturedImage: UIImage?
    @State private var styleQuery = ""
    @State private var resultCount = 3
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.quinary)
                            .frame(height: 300)

                        if let image = capturedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        } else {
                            VStack(spacing: 12) {
                                Image(systemName: "camera.viewfinder")
                                    .font(.system(size: 48))
                                    .foregroundStyle(.tertiary)
                                Text("Snap your garment")
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                                Text("Take a photo of what you want to style")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                    }
                    .onTapGesture {
                        showCamera = true
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("What are you wearing it with?")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        TextField("e.g. a t-shirt, sneakers, a blazer...", text: $styleQuery)
                            .textFieldStyle(.roundedBorder)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("How many looks?")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        HStack {
                            Stepper("\(resultCount) suggestions", value: $resultCount, in: 1...10)
                        }
                    }

                    Button {
                        generateLooks()
                    } label: {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            }
                            Label("Get Style Ideas", systemImage: "sparkles")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            capturedImage == nil || styleQuery.isEmpty || isLoading
                                ? AnyShapeStyle(.pink.opacity(0.4))
                                : AnyShapeStyle(.pink.gradient)
                        )
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .disabled(capturedImage == nil || styleQuery.isEmpty || isLoading)

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding()
            }
            .navigationTitle("StyleMate")
            .sheet(isPresented: $showCamera) {
                ImagePicker(image: $capturedImage)
            }
        }
    }

    private func generateLooks() {
        guard let image = capturedImage, !styleQuery.isEmpty else { return }
        isLoading = true
        errorMessage = nil

        let query = styleQuery
        let count = resultCount

        Task {
            do {
                let results = try await StyleService.shared.generateSuggestions(
                    image: image,
                    query: query,
                    count: count
                )
                suggestions = results
                isLoading = false
                selectedTab = 1
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    CameraView(suggestions: .constant([]), selectedTab: .constant(0))
}
