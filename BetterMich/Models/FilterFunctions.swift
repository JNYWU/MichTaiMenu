import SwiftUI
import Algorithms

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
    let cityOrder = FilterSheetData.cityList
    let cityRank = cityOrder.firstIndex(of: restaurant.City) ?? Int.max
    return RestaurantSortKey(
        distRank: distRank,
        bibRank: bibRank,
        cityRank: cityRank,
        name: restaurant.Name,
        id: restaurant.id
    )
}

// function for sorting restaurants
func sortRestaurants(restaurants: [Restaurant], isSortedByDist: Bool) -> [Restaurant] {
    restaurants.sorted { left, right in
        sortKey(for: left, isSortedByDist: isSortedByDist)
            < sortKey(for: right, isSortedByDist: isSortedByDist)
    }
}

// function to filter with cities
func cityFilter(allRestaurants: [Restaurant], isFilteredByCity: [Bool], isFilteredByDist: [Bool]) -> [Restaurant] {
    
    var outputList: [Restaurant] = []
    let cityList = FilterSheetData.cityList
    
    for (index, city) in cityList.enumerated() {
        if index < isFilteredByCity.count, isFilteredByCity[index] {
            outputList += allRestaurants.filter({ $0.City == city })
        }
    }
    
    if !isFilteredByCity.contains(true) {
        return allRestaurants
    }
    
    outputList = Array(outputList.uniqued())
    
    return outputList
    
}

// function to filter with distinctions
func distFilter(allRestaurants: [Restaurant], isFilteredByCity: [Bool], isFilteredByDist: [Bool]) -> [Restaurant] {
    
    var outputList: [Restaurant] = []
    
    for filterOption in 0...4 {
        if isFilteredByDist[filterOption] {
            switch filterOption {
                
            // filter 3 stars
            case 0:
                outputList += allRestaurants.filter({ $0.Distinction == 3})
               
            // filter 2 stars
            case 1:
                outputList += allRestaurants.filter({ $0.Distinction == 2})
               
            // filter 1 star
            case 2:
                outputList += allRestaurants.filter({ $0.Distinction == 1})
              
            // filter Bibendum
            case 3:
                outputList += allRestaurants.filter({ $0.Bibendum == true })

            // filter Plate
            default:
                outputList += allRestaurants.filter({ $0.Distinction == 0 && $0.Bibendum == false })
            }
        }
        
    }
    
    if !isFilteredByDist.contains(true) {
        return allRestaurants
    }
    
    outputList = Array(outputList.uniqued())
    
    return outputList
}

// function to filter Sustainable
func sustainFilter(Restaurants: [Restaurant], isFilteredBySus: Bool) -> [Restaurant] {
    
    var outputList: [Restaurant] = []
    
    outputList = Restaurants.filter({ $0.Sustainable == true })
    
    if !isFilteredBySus {
        return Restaurants
    }
    
    return outputList
}

// function to filter New
func newFilter(Restaurants: [Restaurant], isFilteredByNew: Bool) -> [Restaurant] {
    
    let outputList = Restaurants.filter({ $0.IsNew == true })
    
    if !isFilteredByNew {
        return Restaurants
    }
    
    return outputList
}
