import SwiftUI

struct FilterSheetView: View {
    @Binding var Restaurants: [Restaurant]
    @Binding var isSortedByDist: Bool
    @Binding var isFilteredByDist: [Bool]
    @Binding var isFilteredByCity: [Bool]
    @Binding var isFilteredBySus: Bool
    @Binding var isFilteredByNew: Bool
    @Binding var sortedRestaurants: [Restaurant]
    @Binding var filteredRestaurants: [Restaurant]
    @Binding var displayedRestaurants: [Restaurant]
    @Binding var isPresented: Bool

    @State private var tempSortedByDist: Bool
    @State private var tempFilteredByDist: [Bool]
    @State private var tempFilteredByCity: [Bool]
    @State private var tempFilteredBySus: Bool
    @State private var tempFilteredByNew: Bool

    private let cityList = ["台北", "新北", "新竹", "台中", "台南", "高雄"]
    private let distList = ["三星", "二星", "一星", "必比登", "推薦"]

    init(
        Restaurants: Binding<[Restaurant]>,
        isSortedByDist: Binding<Bool>,
        isFilteredByDist: Binding<[Bool]>,
        isFilteredByCity: Binding<[Bool]>,
        isFilteredBySus: Binding<Bool>,
        isFilteredByNew: Binding<Bool>,
        sortedRestaurants: Binding<[Restaurant]>,
        filteredRestaurants: Binding<[Restaurant]>,
        displayedRestaurants: Binding<[Restaurant]>,
        isPresented: Binding<Bool>
    ) {
        self._Restaurants = Restaurants
        self._isSortedByDist = isSortedByDist
        self._isFilteredByDist = isFilteredByDist
        self._isFilteredByCity = isFilteredByCity
        self._isFilteredBySus = isFilteredBySus
        self._isFilteredByNew = isFilteredByNew
        self._sortedRestaurants = sortedRestaurants
        self._filteredRestaurants = filteredRestaurants
        self._displayedRestaurants = displayedRestaurants
        self._isPresented = isPresented

        self._tempSortedByDist = State(initialValue: isSortedByDist.wrappedValue)
        self._tempFilteredByDist = State(initialValue: isFilteredByDist.wrappedValue)
        self._tempFilteredByCity = State(initialValue: isFilteredByCity.wrappedValue)
        self._tempFilteredBySus = State(initialValue: isFilteredBySus.wrappedValue)
        self._tempFilteredByNew = State(initialValue: isFilteredByNew.wrappedValue)
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                    sectionHeader("排序")
                    Button {
                        tempSortedByDist.toggle()
                    } label: {
                        HStack {
                            Image(systemName: tempSortedByDist ? "arrowshape.up.fill" : "arrowshape.down.fill")
                            Text("評鑑等級")
                        }
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .frame(height: 24)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color(UIColor.systemGray5))
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)

                    Divider()
                    
                    sectionHeader("篩選")
                    HStack(spacing: 12) {
                        toggleChip(title: "新入選", isOn: $tempFilteredByNew, tint: .red, icon: "sparkles.2", fixedWidth: 75)
                    }
                    sectionHeader("城市", isSubsection: true, systemImage: "building.2")
                    cityChipGrid(items: cityList, selected: $tempFilteredByCity, tint: .teal)

                    sectionHeader("評鑑等級", isSubsection: true, systemImage: "star.bubble")
                    distChipGrid(selected: $tempFilteredByDist, isFilteredBySus: $tempFilteredBySus)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .navigationTitle("篩選")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .destructive) {
                        resetFilters()
                    } label: {
                        Image(systemName: "arrow.trianglehead.2.clockwise")
                            .font(.subheadline.bold())
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.subheadline.bold())
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }
            }
            .onChange(of: tempSortedByDist) { _, _ in applyFilters() }
            .onChange(of: tempFilteredByDist) { _, _ in applyFilters() }
            .onChange(of: tempFilteredByCity) { _, _ in applyFilters() }
            .onChange(of: tempFilteredBySus) { _, _ in applyFilters() }
            .onChange(of: tempFilteredByNew) { _, _ in applyFilters() }
        }
    }

    private func sectionHeader(_ text: String, isSubsection: Bool = false, systemImage: String? = nil) -> some View {
        HStack(spacing: 6) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(isSubsection ? .subheadline.bold() : .headline)
                    .foregroundStyle(isSubsection ? Color(.darkGray) : .primary)
            }
            Text(text)
                .font(isSubsection ? .subheadline.bold() : .headline)
                .foregroundStyle(isSubsection ? Color(.darkGray) : .primary)
        }
    }

    private func cityChipGrid(items: [String], selected: Binding<[Bool]>, tint: Color) -> some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 8, alignment: .leading), count: 3)
        return LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
            ForEach(items.indices, id: \.self) { index in
                let isOn = index < selected.wrappedValue.count && selected.wrappedValue[index]
                Button {
                    if index < selected.wrappedValue.count {
                        selected.wrappedValue[index].toggle()
                    }
                } label: {
                    Text(items[index])
                        .font(.subheadline)
                        .foregroundStyle(isOn ? .white : .primary)
                        .frame(width: 75, height: 24, alignment: .center)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(isOn ? tint : Color(UIColor.systemGray5))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func distChipGrid(selected: Binding<[Bool]>, isFilteredBySus: Binding<Bool>) -> some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 8, alignment: .leading), count: 3)
        let items: [DistFilterItem] = [.threeStars, .twoStars, .oneStar, .bibendum, .plate, .greenStar]
        return LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
            ForEach(items.indices, id: \.self) { index in
                let item = items[index]
                let isOn = isItemSelected(item, selected: selected, isFilteredBySus: isFilteredBySus)
                Button {
                    toggleItem(item, selected: selected, isFilteredBySus: isFilteredBySus)
                } label: {
                    distItemView(item, isSelected: isOn)
                        .frame(width: 75, height: 24, alignment: .center)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(isOn ? selectedTint(item) : Color(UIColor.systemGray5))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
    }

    private enum DistFilterItem {
        case threeStars
        case twoStars
        case oneStar
        case bibendum
        case plate
        case greenStar
    }

    private func selectedTint(_ item: DistFilterItem) -> Color {
        switch item {
        case .greenStar:
            return .green
        default:
            return .red
        }
    }

    private func isItemSelected(_ item: DistFilterItem, selected: Binding<[Bool]>, isFilteredBySus: Binding<Bool>) -> Bool {
        switch item {
        case .threeStars:
            return selected.wrappedValue.count > 0 && selected.wrappedValue[0]
        case .twoStars:
            return selected.wrappedValue.count > 1 && selected.wrappedValue[1]
        case .oneStar:
            return selected.wrappedValue.count > 2 && selected.wrappedValue[2]
        case .bibendum:
            return selected.wrappedValue.count > 3 && selected.wrappedValue[3]
        case .plate:
            return selected.wrappedValue.count > 4 && selected.wrappedValue[4]
        case .greenStar:
            return isFilteredBySus.wrappedValue
        }
    }

    private func toggleItem(_ item: DistFilterItem, selected: Binding<[Bool]>, isFilteredBySus: Binding<Bool>) {
        switch item {
        case .threeStars:
            if selected.wrappedValue.count > 0 { selected.wrappedValue[0].toggle() }
        case .twoStars:
            if selected.wrappedValue.count > 1 { selected.wrappedValue[1].toggle() }
        case .oneStar:
            if selected.wrappedValue.count > 2 { selected.wrappedValue[2].toggle() }
        case .bibendum:
            if selected.wrappedValue.count > 3 { selected.wrappedValue[3].toggle() }
        case .plate:
            if selected.wrappedValue.count > 4 { selected.wrappedValue[4].toggle() }
        case .greenStar:
            isFilteredBySus.wrappedValue.toggle()
        }
    }

    @ViewBuilder
    private func distItemView(_ item: DistFilterItem, isSelected: Bool) -> some View {
        let tint = isSelected ? Color.white : selectedTint(item)
        let sustainableTint = isSelected ? Color.white : Color.green
        switch item {
        case .threeStars:
            DistinctionView(distinction: 3, bibendum: false, sustainable: false, tintColor: tint)
        case .twoStars:
            DistinctionView(distinction: 2, bibendum: false, sustainable: false, tintColor: tint)
        case .oneStar:
            DistinctionView(distinction: 1, bibendum: false, sustainable: false, tintColor: tint)
        case .bibendum:
            DistinctionView(distinction: 0, bibendum: true, sustainable: false, tintColor: tint)
        case .plate:
            DistinctionView(distinction: 0, bibendum: false, sustainable: false, tintColor: tint)
        case .greenStar:
            DistinctionView(sustainableOnly: true, sustainableTint: sustainableTint)
        }
    }

    private func toggleChip(title: String, isOn: Binding<Bool>, tint: Color, icon: String, fixedWidth: CGFloat? = nil) -> some View {
        Button {
            isOn.wrappedValue.toggle()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(title)
            }
            .font(.subheadline)
            .foregroundStyle(isOn.wrappedValue ? .white : .primary)
            .frame(width: fixedWidth, height: 24, alignment: .center)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(isOn.wrappedValue ? tint : Color(UIColor.systemGray5))
            .clipShape(Capsule())
        }
    }

    private func applyFilters() {
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

    private func resetFilters() {
        isFilteredByDist = Array(repeating: false, count: distList.count)
        isFilteredByCity = Array(repeating: false, count: cityList.count)
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

private struct FilterSheetPreviewHost: View {
    @State private var restaurants: [Restaurant] = [
        Restaurant(
            id: 1,
            name: "示範餐廳",
            distinction: 1,
            sustainable: false,
            bibendum: false,
            isNew: true,
            city: "台北",
            restaurantType: "現代料理",
            phone: "+886 2 1234 5678",
            img: "https://axwwgrkdco.cloudimg.io/v7/__gmpics3__/a2d64509aac140db8f1dee827c7ffa1c.jpeg?width=1000",
            address: "台北市中正區",
            description: "示範用餐廳描述"
        )
    ]
    @State private var isSortedByDist = false
    @State private var isFilteredByDist = Array(repeating: false, count: 5)
    @State private var isFilteredByCity = Array(repeating: false, count: 6)
    @State private var isFilteredBySus = false
    @State private var isFilteredByNew = false
    @State private var sortedRestaurants: [Restaurant] = []
    @State private var filteredRestaurants: [Restaurant] = []
    @State private var displayedRestaurants: [Restaurant] = []
    @State private var isPresented = true

    var body: some View {
        FilterSheetView(
            Restaurants: $restaurants,
            isSortedByDist: $isSortedByDist,
            isFilteredByDist: $isFilteredByDist,
            isFilteredByCity: $isFilteredByCity,
            isFilteredBySus: $isFilteredBySus,
            isFilteredByNew: $isFilteredByNew,
            sortedRestaurants: $sortedRestaurants,
            filteredRestaurants: $filteredRestaurants,
            displayedRestaurants: $displayedRestaurants,
            isPresented: $isPresented
        )
    }
}

#Preview {
    FilterSheetPreviewHost()
}
