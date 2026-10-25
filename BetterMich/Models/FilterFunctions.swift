private struct RestaurantSortKey: Comparable {
    let distRank: Int
    let bibRank: Int
    let cityRank: Int
    let name: String
    let id: String

    static func < (lhs: RestaurantSortKey, rhs: RestaurantSortKey) -> Bool {
        if lhs.distRank != rhs.distRank { return lhs.distRank < rhs.distRank }
        if lhs.bibRank != rhs.bibRank { return lhs.bibRank < rhs.bibRank }
        if lhs.cityRank != rhs.cityRank { return lhs.cityRank < rhs.cityRank }
        if lhs.name != rhs.name { return lhs.name < rhs.name }
        return lhs.id < rhs.id
    }
}

private let cityRankByName: [String: Int] = Dictionary(
    uniqueKeysWithValues: FilterSheetData.cityList.enumerated().map {
        ($0.element, $0.offset)
    }
)

private func sortKey(for restaurant: Restaurant, isSortedByDist: Bool) -> RestaurantSortKey {
    let distRank = isSortedByDist ? restaurant.Distinction : -restaurant.Distinction
    let bibRank: Int
    if restaurant.Distinction == 0 {
        bibRank = restaurant.Bibendum
            ? (isSortedByDist ? 1 : 0)
            : (isSortedByDist ? 0 : 1)
    } else {
        bibRank = 0
    }
    let cityRank = cityRankByName[restaurant.City] ?? Int.max
    return RestaurantSortKey(
        distRank: distRank,
        bibRank: bibRank,
        cityRank: cityRank,
        name: restaurant.Name,
        id: restaurant.id
    )
}

func sortRestaurants(restaurants: [Restaurant], isSortedByDist: Bool) -> [Restaurant] {
    restaurants.sorted { left, right in
        sortKey(for: left, isSortedByDist: isSortedByDist)
            < sortKey(for: right, isSortedByDist: isSortedByDist)
    }
}

func makeDisplayedRestaurants(
    restaurants: [Restaurant],
    isSortedByDist: Bool,
    isFilteredByCity: [Bool],
    isFilteredByDist: [Bool],
    isFilteredBySus: Bool,
    isFilteredByNew: Bool
) -> [Restaurant] {
    let filtered = restaurants.filter {
        matchesFilters(
            $0,
            isFilteredByCity: isFilteredByCity,
            isFilteredByDist: isFilteredByDist,
            isFilteredBySus: isFilteredBySus,
            isFilteredByNew: isFilteredByNew
        )
    }
    return sortRestaurants(restaurants: filtered, isSortedByDist: isSortedByDist)
}

func makeSearchedRestaurants(
    restaurants: [Restaurant],
    searchText: String
) -> [Restaurant] {
    guard !searchText.isEmpty else { return restaurants }
    return restaurants.filter { restaurant in
        restaurant.Name.localizedCaseInsensitiveContains(searchText)
            || restaurant.City.localizedCaseInsensitiveContains(searchText)
            || restaurant.RestaurantType.localizedCaseInsensitiveContains(searchText)
    }
}

private func matchesFilters(
    _ restaurant: Restaurant,
    isFilteredByCity: [Bool],
    isFilteredByDist: [Bool],
    isFilteredBySus: Bool,
    isFilteredByNew: Bool
) -> Bool {
    if isFilteredByCity.contains(true) {
        let cityMatches = FilterSheetData.cityList.indices.contains(where: { index in
            index < isFilteredByCity.count
                && isFilteredByCity[index]
                && restaurant.City == FilterSheetData.cityList[index]
        })
        if !cityMatches { return false }
    }

    if isFilteredByDist.contains(true) {
        let distMatches = isFilteredByDist.indices.contains(where: { index in
            guard isFilteredByDist[index] else { return false }
            switch index {
            case 0:
                return restaurant.Distinction == 3
            case 1:
                return restaurant.Distinction == 2
            case 2:
                return restaurant.Distinction == 1
            case 3:
                return restaurant.Bibendum
            default:
                return restaurant.Distinction == 0 && !restaurant.Bibendum
            }
        })
        if !distMatches { return false }
    }

    if isFilteredBySus && !restaurant.Sustainable { return false }
    if isFilteredByNew && !restaurant.IsNew { return false }
    return true
}
