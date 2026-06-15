import SwiftUI

struct CameraView: View {
    @State private var showCamera = false
    @State private var capturedImage: UIImage?
    @State private var styleQuery = ""
    @State private var resultCount = 3

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Camera / Photo area
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

                    // Style query
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What are you wearing it with?")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        TextField("e.g. a t-shirt, sneakers, a blazer...", text: $styleQuery)
                            .textFieldStyle(.roundedBorder)
                    }

                    // Result count
                    VStack(alignment: .leading, spacing: 8) {
                        Text("How many looks?")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        HStack {
                            Stepper("\(resultCount) suggestions", value: $resultCount, in: 1...10)
                        }
                    }

                    // Generate button
                    Button {
                        generateLooks()
                    } label: {
                        Label("Get Style Ideas", systemImage: "sparkles")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.pink.gradient)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .disabled(capturedImage == nil || styleQuery.isEmpty)
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
        // TODO: Connect to vision API to generate style suggestions
        print("Generate looks for: \(styleQuery), count: \(resultCount)")
    }
}

#Preview {
    CameraView()
}
