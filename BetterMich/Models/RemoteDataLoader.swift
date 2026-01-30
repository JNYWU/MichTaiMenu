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
    let id: String?
    let name: String
    let phone: String?
    let badge: String?
    let award: [String]?
    let awardHistory: [AwardHistoryItem]?
    let sustainable: Bool?
    let address: String?
    let price: String?
    let type: String?
    let description: String?
    let imageURL: String?
    let etl_dtm: String?

    enum CodingKeys: String, CodingKey {
        case id, name, phone, badge, award, awardHistory, award_history, sustainable, address, price, type, description, etl_dtm
        case imageURL = "image_url"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        badge = try container.decodeIfPresent(String.self, forKey: .badge)
        award = try container.decodeIfPresent([String].self, forKey: .award)
        awardHistory =
            try container.decodeIfPresent([AwardHistoryItem].self, forKey: .awardHistory)
            ?? container.decodeIfPresent([AwardHistoryItem].self, forKey: .award_history)
        sustainable = try container.decodeIfPresent(Bool.self, forKey: .sustainable)
        address = try container.decodeIfPresent(String.self, forKey: .address)
        price = try container.decodeIfPresent(String.self, forKey: .price)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        etl_dtm = try container.decodeIfPresent(String.self, forKey: .etl_dtm)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(phone, forKey: .phone)
        try container.encodeIfPresent(badge, forKey: .badge)
        try container.encodeIfPresent(award, forKey: .award)
        try container.encodeIfPresent(awardHistory, forKey: .awardHistory)
        try container.encodeIfPresent(sustainable, forKey: .sustainable)
        try container.encodeIfPresent(address, forKey: .address)
        try container.encodeIfPresent(price, forKey: .price)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(imageURL, forKey: .imageURL)
        try container.encodeIfPresent(etl_dtm, forKey: .etl_dtm)
    }
}

struct AwardHistoryItem: Codable {
    let award: [String]?
    let at: String?

    enum CodingKeys: String, CodingKey {
        case award, at
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let awards = try container.decodeIfPresent([String].self, forKey: .award) {
            award = awards
        } else if let awardString = try container.decodeIfPresent(String.self, forKey: .award) {
            award = [awardString]
        } else {
            award = nil
        }
        at = try container.decodeIfPresent(String.self, forKey: .at)
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
    payload.restaurants.map { dto in
        mapRestaurant(dto: dto)
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

private func mapRestaurant(dto: RestaurantDTO) -> Restaurant {
    let meta = parseDistinction(award: dto.award, badge: dto.badge)
    let isNew = parseNewBadge(badge: dto.badge)
    let city = parseCity(from: dto.address)
    let type = dto.type ?? ""
    let phone = dto.phone ?? ""
    let imageURL = dto.imageURL ?? ""
    let address = dto.address ?? ""
    let description = dto.description ?? ""
    let restaurantId = normalizedId(from: dto)
    let awardHistory = parseAwardHistory(dto.awardHistory)

    let sustainable = dto.sustainable ?? meta.sustainable
    return Restaurant(
        id: restaurantId,
        name: dto.name,
        distinction: meta.stars,
        sustainable: sustainable,
        bibendum: meta.bibendum,
        isNew: isNew,
        city: city,
        restaurantType: type,
        phone: phone,
        img: imageURL,
        address: address,
        description: description,
        awardHistory: awardHistory
    )
}

private func normalizedId(from dto: RestaurantDTO) -> String {
    let trimmed = dto.id?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    if !trimmed.isEmpty {
        return trimmed
    }
    return dto.name
}

private func parseAwardHistory(_ items: [AwardHistoryItem]?) -> [AwardHistoryEntry] {
    guard let items else { return [] }
    return items.compactMap { item in
        guard let year = yearString(from: item.at) else { return nil }
        let meta = parseDistinction(award: item.award, badge: nil)
        return AwardHistoryEntry(
            year: year,
            distinction: meta.stars,
            bibendum: meta.bibendum,
            sustainable: meta.sustainable
        )
    }
}

private func yearString(from isoString: String?) -> String? {
    guard let isoString, !isoString.isEmpty else { return nil }
    let parts = isoString.split(separator: "-")
    guard let year = parts.first else { return nil }
    return String(year)
}

private func parseDistinction(award: [String]?, badge: String?) -> (stars: Int, bibendum: Bool, sustainable: Bool) {
    let text = ([badge] + (award ?? [])).compactMap { $0 }.joined(separator: " ").lowercased()
    let normalized = normalizeAwardText(text)
    let isSustainable = containsAny(text, ["green star", "green-star", "綠星"])
        || containsAny(normalized, ["greenstar", "綠星"])
    let isBibendum = containsAny(text, ["bib gourmand", "bib-gourmand", "必比登"])
        || containsAny(normalized, ["bibgourmand", "必比登"])

    let stars = parseStarCount(text: text, normalized: normalized) ?? 0
    return (stars, isBibendum, isSustainable)
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

private func parseNewBadge(badge: String?) -> Bool {
    let text = (badge ?? "").lowercased()
    return containsAny(text, ["new", "新", "新入選", "新進"])
}

private func containsAny(_ text: String, _ patterns: [String]) -> Bool {
    for pattern in patterns {
        if text.contains(pattern.lowercased()) {
            return true
        }
    }
    return false
}

private func normalizeAwardText(_ text: String) -> String {
    let withoutWhitespace = text.replacingOccurrences(
        of: "\\s+",
        with: "",
        options: .regularExpression
    )
    return withoutWhitespace.replacingOccurrences(
        of: "[:：\\-—_]",
        with: "",
        options: .regularExpression
    )
}

private func parseStarCount(text: String, normalized: String) -> Int? {
    if containsAny(text, ["3 star", "3-star", "three star", "three-star", "三星", "3星"])
        || containsAny(normalized, ["3star", "threestar", "三星", "3星", "michelin3star"]) {
        return 3
    }
    if containsAny(text, ["2 star", "2-star", "two star", "two-star", "二星", "2星"])
        || containsAny(normalized, ["2star", "twostar", "二星", "2星", "michelin2star"]) {
        return 2
    }
    if containsAny(text, ["1 star", "1-star", "one star", "one-star", "一星", "1星"])
        || containsAny(normalized, ["1star", "onestar", "一星", "1星", "michelin1star"]) {
        return 1
    }

    let starSymbols = text.filter { $0 == "★" || $0 == "⭐" }
    if !starSymbols.isEmpty {
        return min(starSymbols.count, 3)
    }
    return nil
}
