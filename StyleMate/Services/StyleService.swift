import UIKit
import SwiftUI

protocol HTTPSession: Sendable {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: HTTPSession {}

actor StyleService {
    static let shared = StyleService()

    private let session: HTTPSession
    private let paletteBaseURL = "https://palett.es/API/v1/palette"

    init(session: HTTPSession = URLSession.shared) {
        self.session = session
    }

    func generateSuggestions(image: UIImage, query: String, count: Int) async throws -> [StyleSuggestion] {
        let hex = extractDominantColor(from: image)
        let baseColor = Color(hex: hex) ?? .gray
        let palette = try await fetchPalette(from: hex)
        let targetType = GarmentType.from(query: query) ?? .fullOutfit

        return palette.prefix(count).enumerated().map { index, colorHex in
            let garment = Garment(type: targetType, color: colorHex, description: "")
            return StyleSuggestion(
                title: "\(targetType.rawValue) \(index + 1)",
                description: query,
                color: Color(hex: colorHex) ?? .gray,
                baseColor: baseColor,
                garments: [garment]
            )
        }
    }

    private func fetchPalette(from color: String) async throws -> [String] {
        let urlString = "\(paletteBaseURL)/from/\(color)"
        guard let url = URL(string: urlString) else {
            throw StyleServiceError.invalidResponse
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw StyleServiceError.apiError("Invalid response from palette service")
        }

        return try JSONDecoder().decode([String].self, from: data)
    }

    private func extractDominantColor(from image: UIImage) -> String {
        guard let cgImage = image.cgImage else { return "808080" }

        var pixel = [UInt8](repeating: 0, count: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(
            data: &pixel,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        )

        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: 1, height: 1))

        let r = pixel[0]
        let g = pixel[1]
        let b = pixel[2]
        return String(format: "%02x%02x%02x", r, g, b)
    }
}

enum StyleServiceError: Error, LocalizedError {
    case invalidResponse
    case apiError(String)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Received an unexpected response from the style service."
        case .apiError(let message):
            return "Style service error: \(message)"
        }
    }
}
