import Testing
import UIKit
import SwiftUI
@testable import StyleMate

// MARK: - Mock Session

struct MockHTTPSession: HTTPSession {
    var testData: Data?
    var testError: URLError?
    var testResponse: URLResponse?

    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let testError {
            throw testError
        }
        return (testData ?? Data(), testResponse ?? URLResponse())
    }
}

// MARK: - Tests

struct StyleMateTests {
    @Test("Garment model creates with correct type and color")
    func garmentCreation() {
        let garment = Garment(type: .bottom, color: "Blue", description: "Slim fit jeans")
        #expect(garment.type == .bottom)
        #expect(garment.color == "Blue")
        #expect(garment.description == "Slim fit jeans")
    }

    @Test("Style suggestion has unique ID")
    func suggestionIDUniqueness() {
        let suggestion1 = StyleSuggestion(
            title: "Casual Look",
            description: "T-shirt with jeans",
            color: .blue,
            baseColor: .gray,
            garments: []
        )
        let suggestion2 = StyleSuggestion(
            title: "Smart Look",
            description: "Blazer with chinos",
            color: .gray,
            baseColor: .blue,
            garments: []
        )
        #expect(suggestion1.id != suggestion2.id)
    }

    @Test("Garment types have correct raw values")
    func garmentTypeRawValues() {
        #expect(GarmentType.top.rawValue == "Top")
        #expect(GarmentType.bottom.rawValue == "Bottom")
        #expect(GarmentType.footwear.rawValue == "Footwear")
        #expect(GarmentType.outerwear.rawValue == "Outerwear")
        #expect(GarmentType.accessory.rawValue == "Accessory")
        #expect(GarmentType.fullOutfit.rawValue == "Full Outfit")
    }

    @Test("StyleService error descriptions are meaningful")
    func serviceErrorDescriptions() {
        let invalidResponse = StyleServiceError.invalidResponse
        #expect(invalidResponse.errorDescription?.isEmpty == false)

        let apiError = StyleServiceError.apiError("Rate limit exceeded")
        #expect(apiError.errorDescription?.contains("Rate limit exceeded") == true)
    }

    @Test("Color hex initializer with 6-character hex")
    func colorHex6Char() {
        #expect(Color(hex: "ff0000") != nil)
        #expect(Color(hex: "00ff00") != nil)
        #expect(Color(hex: "0000ff") != nil)
    }

    @Test("Color hex initializer with 3-character hex")
    func colorHex3Char() {
        #expect(Color(hex: "f00") != nil)
        #expect(Color(hex: "0f0") != nil)
    }

    @Test("Color hex initializer with 8-character hex (RGBA)")
    func colorHex8Char() {
        #expect(Color(hex: "ff000080") != nil)
    }

    @Test("Color hex initializer strips hash prefix")
    func colorHexWithHash() {
        #expect(Color(hex: "#ff0000") != nil)
    }

    @Test("Color hex initializer returns nil for invalid input")
    func colorHexInvalid() {
        #expect(Color(hex: "xyz") == nil)
        #expect(Color(hex: "") == nil)
    }

    @Test("Safe array subscript returns element for valid index")
    func safeSubscriptValid() {
        let array = [10, 20, 30]
        #expect(array[safe: 0] == 10)
        #expect(array[safe: 2] == 30)
    }

    @Test("Safe array subscript returns nil for out-of-bounds index")
    func safeSubscriptInvalid() {
        let array = [10, 20, 30]
        #expect(array[safe: -1] == nil)
        #expect(array[safe: 5] == nil)
    }

    @Test("generateSuggestions returns correct number of suggestions on success")
    func generateSuggestionsSuccess() async throws {
        let mockSession = MockHTTPSession(
            testData: ##"["#c1bdc1","#696818","#84862c","#a69d72","#45192a"]"##.data(using: .utf8),
            testError: nil,
            testResponse: HTTPURLResponse(
                url: URL(string: "http://palett.es/API/v1/palette")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
        )

        let service = StyleService(session: mockSession)
        let image = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in }
        let suggestions = try await service.generateSuggestions(
            image: image,
            query: "casual summer",
            count: 3
        )

        #expect(suggestions.count == 3)
        #expect(suggestions[0].title == "Full Outfit 1")
        #expect(suggestions[1].title == "Full Outfit 2")
        #expect(suggestions[2].title == "Full Outfit 3")
        #expect(suggestions[0].description == "casual summer")
    }

    @Test("generateSuggestions respects count parameter")
    func generateSuggestionsCount() async throws {
        let mockSession = MockHTTPSession(
            testData: ##"["#111","#222","#333","#444","#555"]"##.data(using: .utf8),
            testError: nil,
            testResponse: HTTPURLResponse(
                url: URL(string: "http://palett.es/API/v1/palette")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
        )

        let service = StyleService(session: mockSession)
        let image = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in }
        let suggestions = try await service.generateSuggestions(
            image: image,
            query: "test",
            count: 1
        )

        #expect(suggestions.count == 1)
        #expect(suggestions[0].title == "Full Outfit 1")
    }

    @Test("generateSuggestions throws on non-200 status code")
    func generateSuggestionsServerError() async throws {
        let mockSession = MockHTTPSession(
            testData: Data(),
            testError: nil,
            testResponse: HTTPURLResponse(
                url: URL(string: "http://palett.es/API/v1/palette")!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )
        )

        let service = StyleService(session: mockSession)
        let image = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in }

        await #expect(throws: StyleServiceError.self) {
            try await service.generateSuggestions(
                image: image,
                query: "test",
                count: 3
            )
        }
    }

    @Test("GarmentType.from matches top keywords in Spanish")
    func garmentTypeFromTopSpanish() {
        #expect(GarmentType.from(query: "camiseta") == .top)
        #expect(GarmentType.from(query: "camisa") == .top)
        #expect(GarmentType.from(query: "blusa") == .top)
    }

    @Test("GarmentType.from matches top keywords in English")
    func garmentTypeFromTopEnglish() {
        #expect(GarmentType.from(query: "t-shirt") == .top)
        #expect(GarmentType.from(query: "shirt") == .top)
        #expect(GarmentType.from(query: "top") == .top)
    }

    @Test("GarmentType.from matches bottom keywords")
    func garmentTypeFromBottom() {
        #expect(GarmentType.from(query: "pantalón") == .bottom)
        #expect(GarmentType.from(query: "jeans") == .bottom)
        #expect(GarmentType.from(query: "pants") == .bottom)
        #expect(GarmentType.from(query: "shorts") == .bottom)
    }

    @Test("GarmentType.from matches footwear keywords")
    func garmentTypeFromFootwear() {
        #expect(GarmentType.from(query: "zapatos") == .footwear)
        #expect(GarmentType.from(query: "sneakers") == .footwear)
        #expect(GarmentType.from(query: "boots") == .footwear)
    }

    @Test("GarmentType.from matches outerwear keywords")
    func garmentTypeFromOuterwear() {
        #expect(GarmentType.from(query: "chaqueta") == .outerwear)
        #expect(GarmentType.from(query: "jacket") == .outerwear)
        #expect(GarmentType.from(query: "sweater") == .outerwear)
    }

    @Test("GarmentType.from matches accessory keywords")
    func garmentTypeFromAccessory() {
        #expect(GarmentType.from(query: "bolso") == .accessory)
        #expect(GarmentType.from(query: "belt") == .accessory)
        #expect(GarmentType.from(query: "hat") == .accessory)
    }

    @Test("GarmentType.from returns nil for unknown query")
    func garmentTypeFromUnknown() {
        #expect(GarmentType.from(query: "casual summer") == nil)
        #expect(GarmentType.from(query: "random text") == nil)
        #expect(GarmentType.from(query: "") == nil)
    }

    @Test("App theme colors are non-nil")
    func appThemeColors() {
        #expect(Color.appBackground != nil)
        #expect(Color.appSurface != nil)
        #expect(Color.appAccent != nil)
        #expect(Color.appAccentSubtle != nil)
        #expect(Color.appBorder != nil)
        #expect(Color.appTextSecondary != nil)
        #expect(Color.appShadow != nil)
        #expect(Color.appError != nil)
    }

    @Test("Palette colors are non-nil")
    func paletteColors() {
        #expect(Color.paletteNavy != nil)
        #expect(Color.paletteOlive != nil)
        #expect(Color.paletteSteel != nil)
        #expect(Color.paletteSlate != nil)
        #expect(Color.paletteBurgundy != nil)
    }

    @Test("SuggestionCard initializes with a suggestion")
    func suggestionCardInitialization() {
        let garment = Garment(type: .top, color: "#2C3E50", description: "Casual top")
        let suggestion = StyleSuggestion(
            title: "Test Look",
            description: "test",
            color: .paletteOlive,
            baseColor: .paletteNavy,
            garments: [garment]
        )
        let card = SuggestionCard(suggestion: suggestion)
        #expect(card.suggestion.title == "Test Look")
        #expect(card.suggestion.garments.count == 1)
    }

    @Test("generateSuggestions uses query to determine garment type")
    func generateSuggestionsWithQuery() async throws {
        let mockSession = MockHTTPSession(
            testData: ##"["#ff0000","#00ff00","#0000ff"]"##.data(using: .utf8),
            testError: nil,
            testResponse: HTTPURLResponse(
                url: URL(string: "http://palett.es/API/v1/palette")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
        )

        let service = StyleService(session: mockSession)
        let image = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in }
        let suggestions = try await service.generateSuggestions(
            image: image,
            query: "jacket",
            count: 2
        )

        #expect(suggestions.count == 2)
        #expect(suggestions[0].title == "Outerwear 1")
        #expect(suggestions[1].title == "Outerwear 2")
        #expect(suggestions[0].description == "jacket")
    }

    @Test("generateSuggestions throws on network error")
    func generateSuggestionsNetworkError() async throws {
        let mockSession = MockHTTPSession(
            testData: nil,
            testError: URLError(.notConnectedToInternet),
            testResponse: nil
        )

        let service = StyleService(session: mockSession)
        let image = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in }

        await #expect(throws: (any Error).self) {
            try await service.generateSuggestions(
                image: image,
                query: "test",
                count: 3
            )
        }
    }
}
