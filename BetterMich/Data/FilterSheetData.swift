import Foundation

enum FilterSheetData {
    static let cityList = ["台北", "新北", "新竹", "台中", "台南", "高雄"]
    static let distList = ["三星", "二星", "一星", "必比登", "推薦"]
    static let distItems: [DistFilterItem] = [
        .threeStars,
        .twoStars,
        .oneStar,
        .bibendum,
        .plate,
        .greenStar
    ]
}

enum DistFilterItem {
    case threeStars
    case twoStars
    case oneStar
    case bibendum
    case plate
    case greenStar
}
