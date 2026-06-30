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
    @FocusState private var isQueryFocused: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    captureArea
                    querySection
                    countSection
                    generateButton
                    if let errorMessage {
                        errorView(errorMessage)
                    }
                }
                .padding(20)
            }
            .background(Color.appBackground)
            .navigationTitle("StyleMate")
            .sheet(isPresented: $showCamera) {
                ImagePicker(image: $capturedImage)
            }
            .onChange(of: capturedImage) { _, newValue in
                if newValue != nil {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            }
        }
    }

    private var captureArea: some View {
        ZStack {
            if let image = capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 340)
                    .clipShape(RoundedRectangle(cornerRadius: 24))

                VStack {
                    HStack {
                        Spacer()
                        Button {
                            capturedImage = nil
                        } label: {
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                                .font(.title2)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white, Color.black.opacity(0.25))
                                .padding(10)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                        .padding(14)
                    }
                    Spacer()
                }
            } else {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.appSurface)
                    .stroke(Color.appBorder, style: StrokeStyle(lineWidth: 2, dash: [10, 10]))
                    .frame(height: 340)

                VStack(spacing: 16) {
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 44, weight: .thin))
                        .foregroundStyle(Color.appAccent)
                    Text("Capture a Garment")
                        .font(.title3.weight(.semibold))
                    Text("Snap a photo to get style suggestions")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .onTapGesture {
            if capturedImage == nil { showCamera = true }
        }
    }

    private var querySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What are you pairing it with?")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.tertiary)
                    .font(.subheadline)

                TextField("e.g. a t-shirt, sneakers, blazer...", text: $styleQuery)
                    .textFieldStyle(.plain)
                    .focused($isQueryFocused)

                if !styleQuery.isEmpty {
                    Button { styleQuery = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.tertiary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(14)
            .background(Color.appSurface, in: RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isQueryFocused ? Color.appAccent : Color.appBorder, lineWidth: 1)
            )
        }
    }

    private var countSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Number of looks")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)

            HStack {
                Text("\(resultCount) suggestion\(resultCount == 1 ? "" : "s")")
                    .font(.body.weight(.medium))
                Spacer()
                HStack(spacing: 0) {
                    Button {
                        if resultCount > 1 { resultCount -= 1 }
                    } label: {
                        Image(systemName: "minus")
                            .font(.body.weight(.semibold))
                            .frame(width: 44, height: 44)
                    }
                    .disabled(resultCount <= 1)
                    .opacity(resultCount > 1 ? 1 : 0.3)

                    Text("\(resultCount)")
                        .font(.title3.weight(.semibold))
                        .frame(minWidth: 40)

                    Button {
                        if resultCount < 10 { resultCount += 1 }
                    } label: {
                        Image(systemName: "plus")
                            .font(.body.weight(.semibold))
                            .frame(width: 44, height: 44)
                    }
                    .disabled(resultCount >= 10)
                    .opacity(resultCount < 10 ? 1 : 0.3)
                }
                .background(Color.appSurface, in: RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.appBorder, lineWidth: 1)
                )
            }
        }
    }

    private var generateButton: some View {
        Button {
            generateLooks()
        } label: {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .tint(Color.appAccentContrast)
                        .scaleEffect(0.9)
                }
                Image(systemName: "wand.and.stars")
                    .font(.subheadline)
                Text(isLoading ? "Finding your style..." : "Generate Looks")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                isFormValid
                    ? AnyShapeStyle(Color.appAccent.gradient)
                    : AnyShapeStyle(Color.appAccent.opacity(0.35))
            )
            .foregroundStyle(Color.appAccentContrast)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .disabled(!isFormValid || isLoading)
    }

    private func errorView(_ message: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(Color.appError)
            Text(message)
                .font(.caption)
                .foregroundStyle(Color.appError)
            Spacer()
            Button { errorMessage = nil } label: {
                Image(systemName: "xmark")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color.appError)
            }
        }
        .padding(12)
        .background(Color.appError.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }

    private var isFormValid: Bool {
        capturedImage != nil && !styleQuery.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private func generateLooks() {
        guard let image = capturedImage, !styleQuery.trimmingCharacters(in: .whitespaces).isEmpty else { return }
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
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                selectedTab = 1
            } catch {
                isLoading = false
                withAnimation {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    CameraView(suggestions: .constant([]), selectedTab: .constant(0))
}
