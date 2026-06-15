import UIKit

/// Service that communicates with a vision-language API to generate style suggestions.
actor StyleService {
    static let shared = StyleService()

    private let session = URLSession.shared
    // TODO: Configure with your API endpoint and key
    private let baseURL = "https://api.example.com/v1"
    private var apiKey: String {
        // Load from secure storage or environment
        ""
    }

    /// Generate style suggestions based on a garment image and style query.
    /// - Parameters:
    ///   - image: The captured garment image
    ///   - query: What the user wants to wear with it
    ///   - count: Number of suggestions desired
    /// - Returns: Array of style suggestions
    func generateSuggestions(image: UIImage, query: String, count: Int) async throws -> [StyleSuggestion] {
        // TODO: Implement API call to vision-language model
        // 1. Compress and encode image
        // 2. Send to vision API with style query
        // 3. Parse response into StyleSuggestion models
        // 4. Return results

        throw StyleServiceError.notImplemented
    }
}

enum StyleServiceError: Error, LocalizedError {
    case notImplemented
    case invalidResponse
    case apiError(String)

    var errorDescription: String? {
        switch self {
        case .notImplemented:
            return "Style generation is not yet implemented. Connect a vision API to get started."
        case .invalidResponse:
            return "Received an unexpected response from the style service."
        case .apiError(let message):
            return "Style service error: \(message)"
        }
    }
}
