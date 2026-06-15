import Testing
@testable import StyleMate

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
            garments: []
        )
        let suggestion2 = StyleSuggestion(
            title: "Smart Look",
            description: "Blazer with chinos",
            color: .gray,
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
        let notImplemented = StyleServiceError.notImplemented
        #expect(notImplemented.errorDescription?.isEmpty == false)

        let invalidResponse = StyleServiceError.invalidResponse
        #expect(invalidResponse.errorDescription?.isEmpty == false)

        let apiError = StyleServiceError.apiError("Rate limit exceeded")
        #expect(apiError.errorDescription?.contains("Rate limit exceeded") == true)
    }
}
