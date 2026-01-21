import SwiftUI

enum FilterSheetDistinction {
    static func selectedTint(_ item: DistFilterItem) -> Color {
        switch item {
        case .greenStar:
            return .green
        default:
            return .red
        }
    }

    static func isItemSelected(_ item: DistFilterItem, selected: [Bool], isFilteredBySus: Bool) -> Bool {
        switch item {
        case .threeStars:
            return selected.count > 0 && selected[0]
        case .twoStars:
            return selected.count > 1 && selected[1]
        case .oneStar:
            return selected.count > 2 && selected[2]
        case .bibendum:
            return selected.count > 3 && selected[3]
        case .plate:
            return selected.count > 4 && selected[4]
        case .greenStar:
            return isFilteredBySus
        }
    }

    static func toggleItem(_ item: DistFilterItem, selected: inout [Bool], isFilteredBySus: inout Bool) {
        switch item {
        case .threeStars:
            if selected.count > 0 { selected[0].toggle() }
        case .twoStars:
            if selected.count > 1 { selected[1].toggle() }
        case .oneStar:
            if selected.count > 2 { selected[2].toggle() }
        case .bibendum:
            if selected.count > 3 { selected[3].toggle() }
        case .plate:
            if selected.count > 4 { selected[4].toggle() }
        case .greenStar:
            isFilteredBySus.toggle()
        }
    }
}
