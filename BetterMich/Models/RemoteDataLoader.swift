import Foundation

struct SignedURLResponse: Decodable {
    let url: String
}

struct MichelinPayload: Codable {
    let etl_dtm: String
    let count: Int
    let restaurants: [RestaurantDTO]
}

struct RestaurantDTO: Codable {
    let name: String
    let phone: String?
    let badge: String?
    let award: [String]?
    let address: String?
    let price: String?
    let type: String?
    let description: String?
    let imageURL: String?
    let etl_dtm: String?

    enum CodingKeys: String, CodingKey {
        case name, phone, badge, award, address, price, type, description, etl_dtm
        case imageURL = "image_url"
    }
}

enum RemoteDataError: Error {
    case invalidSignedURL
    case emptyPayload
}

func fetchRemotePayload() async throws -> MichelinPayload {
    let signedURL = try await fetchSignedURL()
    let (data, _) = try await URLSession.shared.data(from: signedURL)
    let payload = try JSONDecoder().decode(MichelinPayload.self, from: data)
    if payload.restaurants.isEmpty {
        throw RemoteDataError.emptyPayload
    }
    return payload
}

func restaurantsFromPayload(_ payload: MichelinPayload) -> [Restaurant] {
    payload.restaurants.enumerated().map { index, dto in
        mapRestaurant(dto: dto, id: index + 1)
    }
}

func yearMonthString(from isoString: String) -> String? {
    let formatter = ISO8601DateFormatter()
    if let date = formatter.date(from: isoString) {
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        return String(format: "%04d/%02d", year, month)
    }
    let parts = isoString.split(separator: "-")
    if parts.count >= 2 {
        return String(format: "%04d/%02d", Int(parts[0]) ?? 0, Int(parts[1]) ?? 0)
    }
    return nil
}

private func fetchSignedURL() async throws -> URL {
    guard var components = URLComponents(string: SignedURLAPI) else {
        throw RemoteDataError.invalidSignedURL
    }
    components.queryItems = [
        URLQueryItem(name: "name", value: SignedURLObjectName)
    ]
    guard let url = components.url else {
        throw RemoteDataError.invalidSignedURL
    }

    var request = URLRequest(url: url)
    request.addValue(SignedURLAPIKey, forHTTPHeaderField: "X-Api-Key")

    let (data, _) = try await URLSession.shared.data(for: request)
    let signedURL = try JSONDecoder().decode(SignedURLResponse.self, from: data)
    guard let finalURL = URL(string: signedURL.url) else {
        throw RemoteDataError.invalidSignedURL
    }
    return finalURL
}

private func mapRestaurant(dto: RestaurantDTO, id: Int) -> Restaurant {
    let meta = parseDistinction(award: dto.award, badge: dto.badge)
    let city = parseCity(from: dto.address)
    let type = dto.type ?? "未知"
    let phone = dto.phone ?? ""
    let imageURL = dto.imageURL ?? ""
    let address = dto.address ?? ""
    let description = dto.description ?? ""

    return Restaurant(
        id: id,
        name: dto.name,
        distinction: meta.stars,
        sustainable: meta.sustainable,
        bibendum: meta.bibendum,
        city: city,
        restaurantType: type,
        phone: phone,
        img: imageURL,
        address: address,
        description: description
    )
}

private func parseDistinction(award: [String]?, badge: String?) -> (stars: Int, bibendum: Bool, sustainable: Bool) {
    let text = ([badge] + (award ?? [])).compactMap { $0 }.joined(separator: " ").lowercased()
    let isSustainable = containsAny(text, ["green star", "green-star", "綠星"])
    let isBibendum = containsAny(text, ["bib gourmand", "bib-gourmand", "必比登"])

    if containsAny(text, ["3 star", "3-star", "three star", "three-star", "三星", "3星"]) {
        return (3, isBibendum, isSustainable)
    }
    if containsAny(text, ["2 star", "2-star", "two star", "two-star", "二星", "2星"]) {
        return (2, isBibendum, isSustainable)
    }
    if containsAny(text, ["1 star", "1-star", "one star", "one-star", "一星", "1星"]) {
        return (1, isBibendum, isSustainable)
    }
    return (0, isBibendum, isSustainable)
}

private func parseCity(from address: String?) -> String {
    let text = (address ?? "").lowercased()
    if containsAny(text, ["新北", "new taipei"]) { return "新北" }
    if containsAny(text, ["台北", "臺北", "taipei"]) { return "台北" }
    if containsAny(text, ["台中", "臺中", "taichung"]) { return "台中" }
    if containsAny(text, ["台南", "臺南", "tainan"]) { return "台南" }
    if containsAny(text, ["高雄", "kaohsiung"]) { return "高雄" }
    if containsAny(text, ["新竹", "hsinchu city", "hsinchu county"]) { return "新竹" }
    return "其他"
}

private func containsAny(_ text: String, _ patterns: [String]) -> Bool {
    for pattern in patterns {
        if text.contains(pattern.lowercased()) {
            return true
        }
    }
    return false
}
