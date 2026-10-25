import Foundation

struct SignedURLResponse: Decodable {
    let url: String
}

struct MichelinPayload: Codable {
    let etl_dtm: String
    let count: Int

    let restaurants: [RestaurantDTO]

    enum CodingKeys: String, CodingKey {
        case etl_dtm, count, restaurants, data, items
    }

    init(etl_dtm: String, count: Int, restaurants: [RestaurantDTO]) {
        self.etl_dtm = etl_dtm
        self.count = count
        self.restaurants = restaurants
    }

    init(from decoder: Decoder) throws {
        if let rootArray = try? LossyDecodableArray<RestaurantDTO>(from: decoder) {
            restaurants = rootArray.elements
            count = restaurants.count
            etl_dtm = ""
            return
        }

        let container = try decoder.container(keyedBy: CodingKeys.self)
        restaurants =
            try container.decodeLossyRestaurantArrayIfPresent(forKey: .restaurants)
            ?? container.decodeLossyRestaurantArrayIfPresent(forKey: .data)
            ?? container.decodeLossyRestaurantArrayIfPresent(forKey: .items)
            ?? []
        count = try container.decodeFlexibleIntIfPresent(forKey: .count) ?? restaurants.count
        etl_dtm = try container.decodeFlexibleStringIfPresent(forKey: .etl_dtm) ?? ""
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(etl_dtm, forKey: .etl_dtm)
        try container.encode(count, forKey: .count)
        try container.encode(restaurants, forKey: .restaurants)
    }
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
        case legacyName = "Name"
        case title
        case restaurantName = "restaurant_name"
        case phoneNumber = "phone_number"
        case legacyPhoneNumber = "PhoneNumber"
        case cuisine
        case legacyCuisine = "Cuisine"
        case legacyAddress = "Address"
        case imageURL = "image_url"
        case imageUrl
        case legacyImageURL = "ImageURL"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeFlexibleStringIfPresent(forKey: .id)
        let decodedName =
            try container.decodeFlexibleStringIfPresent(forKey: .name)
            ?? container.decodeFlexibleStringIfPresent(forKey: .legacyName)
            ?? container.decodeFlexibleStringIfPresent(forKey: .title)
            ?? container.decodeFlexibleStringIfPresent(forKey: .restaurantName)
        guard let decodedName, !decodedName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw DecodingError.keyNotFound(
                CodingKeys.name,
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Restaurant is missing a non-empty name"
                )
            )
        }
        name = decodedName
        phone =
            try container.decodeFlexibleStringIfPresent(forKey: .phone)
            ?? container.decodeFlexibleStringIfPresent(forKey: .phoneNumber)
            ?? container.decodeFlexibleStringIfPresent(forKey: .legacyPhoneNumber)
        badge = try container.decodeFlexibleStringIfPresent(forKey: .badge)
        award = try container.decodeFlexibleStringArrayIfPresent(forKey: .award)
        awardHistory =
            try container.decodeIfPresent([AwardHistoryItem].self, forKey: .awardHistory)
            ?? container.decodeIfPresent([AwardHistoryItem].self, forKey: .award_history)
        sustainable = try container.decodeFlexibleBoolIfPresent(forKey: .sustainable)
        address =
            try container.decodeFlexibleStringIfPresent(forKey: .address)
            ?? container.decodeFlexibleStringIfPresent(forKey: .legacyAddress)
        price = try container.decodeFlexibleStringIfPresent(forKey: .price)
        type =
            try container.decodeFlexibleStringIfPresent(forKey: .type)
            ?? container.decodeFlexibleStringIfPresent(forKey: .cuisine)
            ?? container.decodeFlexibleStringIfPresent(forKey: .legacyCuisine)
        description = try container.decodeFlexibleStringIfPresent(forKey: .description)
        imageURL =
            try container.decodeFlexibleStringIfPresent(forKey: .imageURL)
            ?? container.decodeFlexibleStringIfPresent(forKey: .imageUrl)
            ?? container.decodeFlexibleStringIfPresent(forKey: .legacyImageURL)
        etl_dtm = try container.decodeFlexibleStringIfPresent(forKey: .etl_dtm)
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
        award = try container.decodeFlexibleStringArrayIfPresent(forKey: .award)
        at = try container.decodeFlexibleStringIfPresent(forKey: .at)
    }
}

enum RemoteDataError: LocalizedError {
    case invalidSignedURL
    case emptyPayload
    case httpStatus(Int, URL?)
    case decodeFailed(String)

    var errorDescription: String? {
        switch self {
        case .invalidSignedURL:
            return "遠端資料連結無效，請稍後再試。"
        case .emptyPayload:
            return "遠端資料沒有任何餐廳項目，可能是資料產生流程輸出了空的 data.json。"
        case .httpStatus(let statusCode, let url):
            if let url {
                return "遠端資料下載失敗（HTTP \(statusCode)）：\(url.absoluteString)"
            }
            return "遠端資料下載失敗（HTTP \(statusCode)）。"
        case .decodeFailed(let reason):
            return "遠端資料格式無法解析：\(reason)"
        }
    }
}

func fetchRemotePayload() async throws -> MichelinPayload {
    let signedURL = try await fetchSignedURL()
    let (data, response) = try await URLSession.shared.data(from: signedURL)
    try validateHTTPResponse(response, fallbackURL: signedURL)
    let payload = try decodeMichelinPayload(from: data)
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

    let (data, response) = try await URLSession.shared.data(for: request)
    try validateHTTPResponse(response, fallbackURL: request.url)
    let signedURL: SignedURLResponse
    do {
        signedURL = try JSONDecoder().decode(SignedURLResponse.self, from: data)
    } catch {
        throw RemoteDataError.decodeFailed(describeDecodeError(error))
    }
    guard let finalURL = URL(string: signedURL.url) else {
        throw RemoteDataError.invalidSignedURL
    }
    return finalURL
}

private func decodeMichelinPayload(from data: Data) throws -> MichelinPayload {
    do {
        return try JSONDecoder().decode(MichelinPayload.self, from: data)
    } catch {
        throw RemoteDataError.decodeFailed(describeDecodeError(error))
    }
}

private func validateHTTPResponse(_ response: URLResponse, fallbackURL: URL?) throws {
    guard let httpResponse = response as? HTTPURLResponse else { return }
    guard (200..<300).contains(httpResponse.statusCode) else {
        throw RemoteDataError.httpStatus(httpResponse.statusCode, httpResponse.url ?? fallbackURL)
    }
}

private func describeDecodeError(_ error: Error) -> String {
    guard let decodingError = error as? DecodingError else {
        return error.localizedDescription
    }

    switch decodingError {
    case .typeMismatch(let type, let context):
        return "欄位 \(codingPathDescription(context.codingPath)) 型別不符，預期 \(type)。\(context.debugDescription)"
    case .valueNotFound(let type, let context):
        return "欄位 \(codingPathDescription(context.codingPath)) 缺少值，預期 \(type)。\(context.debugDescription)"
    case .keyNotFound(let key, let context):
        return "缺少欄位 \(codingPathDescription(context.codingPath + [key]))。\(context.debugDescription)"
    case .dataCorrupted(let context):
        return "資料損毀於 \(codingPathDescription(context.codingPath))。\(context.debugDescription)"
    @unknown default:
        return decodingError.localizedDescription
    }
}

private func codingPathDescription(_ codingPath: [CodingKey]) -> String {
    let path = codingPath.map(\.stringValue).joined(separator: ".")
    return path.isEmpty ? "<root>" : path
}

private struct LossyDecodableArray<Element: Decodable>: Decodable {
    let elements: [Element]

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var elements: [Element] = []
        while !container.isAtEnd {
            if let element = try? container.decode(Element.self) {
                elements.append(element)
            } else {
                _ = try? container.decode(JSONValue.self)
            }
        }
        self.elements = elements
    }
}

private indirect enum JSONValue: Decodable {
    case object([String: JSONValue])
    case array([JSONValue])
    case string(String)
    case number(Double)
    case bool(Bool)
    case null

    init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DynamicCodingKey.self) {
            var object: [String: JSONValue] = [:]
            for key in container.allKeys {
                object[key.stringValue] = try container.decode(JSONValue.self, forKey: key)
            }
            self = .object(object)
            return
        }

        if var container = try? decoder.unkeyedContainer() {
            var array: [JSONValue] = []
            while !container.isAtEnd {
                array.append(try container.decode(JSONValue.self))
            }
            self = .array(array)
            return
        }

        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .null
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode(Double.self) {
            self = .number(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Unsupported JSON value"
                )
            )
        }
    }
}

private struct DynamicCodingKey: CodingKey {
    let stringValue: String
    let intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
        intValue = nil
    }

    init?(intValue: Int) {
        stringValue = String(intValue)
        self.intValue = intValue
    }
}

private extension KeyedDecodingContainer {
    func decodeFlexibleStringIfPresent(forKey key: Key) throws -> String? {
        if try decodeNilIfPresent(forKey: key) {
            return nil
        }
        if let value = try? decode(String.self, forKey: key) {
            return value
        }
        if let value = try? decode(Int.self, forKey: key) {
            return String(value)
        }
        if let value = try? decode(Double.self, forKey: key) {
            return String(value)
        }
        if let value = try? decode(Bool.self, forKey: key) {
            return value ? "true" : "false"
        }
        return nil
    }

    func decodeFlexibleIntIfPresent(forKey key: Key) throws -> Int? {
        if try decodeNilIfPresent(forKey: key) {
            return nil
        }
        if let value = try? decode(Int.self, forKey: key) {
            return value
        }
        if let value = try? decode(Double.self, forKey: key) {
            return Int(value)
        }
        if let value = try? decode(String.self, forKey: key) {
            return Int(value.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        return nil
    }

    func decodeFlexibleBoolIfPresent(forKey key: Key) throws -> Bool? {
        if try decodeNilIfPresent(forKey: key) {
            return nil
        }
        if let value = try? decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? decode(Int.self, forKey: key) {
            return value != 0
        }
        if let value = try? decode(String.self, forKey: key) {
            switch value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
            case "true", "yes", "y", "1":
                return true
            case "false", "no", "n", "0":
                return false
            default:
                return nil
            }
        }
        return nil
    }

    func decodeFlexibleStringArrayIfPresent(forKey key: Key) throws -> [String]? {
        if try decodeNilIfPresent(forKey: key) {
            return nil
        }
        if let value = try? decode([String].self, forKey: key) {
            return value
        }
        if let value = try decodeFlexibleStringIfPresent(forKey: key) {
            return [value]
        }
        if let values = try? decode([JSONValue].self, forKey: key) {
            let strings = values.compactMap { value -> String? in
                switch value {
                case .string(let string):
                    return string
                case .number(let number):
                    return String(number)
                case .bool(let bool):
                    return bool ? "true" : "false"
                case .object, .array, .null:
                    return nil
                }
            }
            return strings.isEmpty ? nil : strings
        }
        return nil
    }

    func decodeLossyRestaurantArrayIfPresent(forKey key: Key) throws -> [RestaurantDTO]? {
        guard contains(key), !(try decodeNilIfPresent(forKey: key)) else {
            return nil
        }
        return try decode(LossyDecodableArray<RestaurantDTO>.self, forKey: key).elements
    }

    private func decodeNilIfPresent(forKey key: Key) throws -> Bool {
        contains(key) && (try decodeNil(forKey: key))
    }
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
