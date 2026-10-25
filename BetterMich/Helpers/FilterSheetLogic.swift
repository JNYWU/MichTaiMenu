import SwiftUI

extension FilterSheetView {
    func applyFilters() {
        isSortedByDist = tempSortedByDist
        isFilteredByDist = tempFilteredByDist
        isFilteredByCity = tempFilteredByCity
        isFilteredBySus = tempFilteredBySus
        isFilteredByNew = tempFilteredByNew
    }

    func resetFilters() {
        isFilteredByDist = Array(repeating: false, count: FilterSheetData.distList.count)
        isFilteredByCity = Array(repeating: false, count: FilterSheetData.cityList.count)
        isFilteredBySus = false
        isFilteredByNew = false
        tempSortedByDist = isSortedByDist
        tempFilteredByDist = isFilteredByDist
        tempFilteredByCity = isFilteredByCity
        tempFilteredBySus = isFilteredBySus
        tempFilteredByNew = isFilteredByNew
    }
}
