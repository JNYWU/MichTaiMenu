import SwiftUI

extension FilterSheetView {
    func applyFilters() {
        isSortedByDist = tempSortedByDist
        isFilteredByDist = tempFilteredByDist
        isFilteredByCity = tempFilteredByCity
        isFilteredBySus = tempFilteredBySus
        isFilteredByNew = tempFilteredByNew

        filteredRestaurants = distFilter(allRestaurants: Restaurants, isFilteredByCity: isFilteredByCity, isFilteredByDist: isFilteredByDist)
        filteredRestaurants = cityFilter(allRestaurants: filteredRestaurants, isFilteredByCity: isFilteredByCity, isFilteredByDist: isFilteredByDist)
        filteredRestaurants = sustainFilter(Restaurants: filteredRestaurants, isFilteredBySus: isFilteredBySus)
        filteredRestaurants = newFilter(Restaurants: filteredRestaurants, isFilteredByNew: isFilteredByNew)
        displayedRestaurants = sortRestaurants(restaurants: filteredRestaurants, isSortedByDist: isSortedByDist)
        sortedRestaurants = displayedRestaurants
    }

    func resetFilters() {
        isFilteredByDist = Array(repeating: false, count: FilterSheetData.distList.count)
        isFilteredByCity = Array(repeating: false, count: FilterSheetData.cityList.count)
        isFilteredBySus = false
        isFilteredByNew = false
        displayedRestaurants = sortRestaurants(restaurants: Restaurants, isSortedByDist: isSortedByDist)
        sortedRestaurants = displayedRestaurants
        tempSortedByDist = isSortedByDist
        tempFilteredByDist = isFilteredByDist
        tempFilteredByCity = isFilteredByCity
        tempFilteredBySus = isFilteredBySus
        tempFilteredByNew = isFilteredByNew
    }
}
