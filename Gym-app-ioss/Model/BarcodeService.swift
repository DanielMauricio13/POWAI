import Foundation

struct OpenFoodFactsResponse: Codable {
    let product: ProductInfo?
}

struct ProductInfo: Codable {
    let product_name: String?
    let nutriments: Nutriments?
}

struct Nutriments: Codable {
    let energy_kcal: Double?
    let proteins: Double?
    let carbohydrates: Double?
    let sugars: Double?

    enum CodingKeys: String, CodingKey {
        case energy_kcal = "energy-kcal_100g"
        case proteins = "proteins_100g"
        case carbohydrates = "carbohydrates_100g"
        case sugars = "sugars_100g"
    }
}

enum BarcodeServiceError: Error {
    case invalidResponse
    case productNotFound
}

class BarcodeService {
    static func fetchFood(for barcode: String) async throws -> Food {
        let urlString = "https://world.openfoodfacts.org/api/v2/product/\(barcode).json"
        guard let url = URL(string: urlString) else { throw BarcodeServiceError.invalidResponse }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw BarcodeServiceError.invalidResponse }
        let decoder = JSONDecoder()
        let result = try decoder.decode(OpenFoodFactsResponse.self, from: data)
        guard let product = result.product else { throw BarcodeServiceError.productNotFound }
        let name = product.product_name ?? "Unknown"
        let nutriments = product.nutriments
        let calories = Int(nutriments?.energy_kcal ?? 0)
        let protein = Int(nutriments?.proteins ?? 0)
        let carbs = Int(nutriments?.carbohydrates ?? 0)
        let sugars = Int(nutriments?.sugars ?? 0)
        return Food(Name: name, Calories: calories, Sugars: sugars, Carbohydrates: carbs, Protein: protein)
    }
}
