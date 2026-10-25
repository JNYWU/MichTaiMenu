import SwiftData
import SwiftUI

struct ContentView: View {

    @EnvironmentObject private var dataStore: MichelinDataStore
    @Environment(\.modelContext) private var modelContext: ModelContext

    @State var searchText = ""
    @State var isSortedByDist = false
    @State var isFilteredByDist = Array(repeating: false, count: 5)
    @State var isFilteredByCity = Array(repeating: false, count: 6)
    @State var isFilteredBySus = false
    @State var isFilteredByNew = false
    @State var showAboutSheet = false
    @State private var showFilterSheet = false

    @State private var hasLoaded = false
    @AppStorage("didMigrateLegacyRestaurantStates")
    private var didMigrateLegacyStates = false

    var body: some View {
        let displayedRestaurants = makeDisplayedRestaurants(
            restaurants: dataStore.restaurants,
            isSortedByDist: isSortedByDist,
            isFilteredByCity: isFilteredByCity,
            isFilteredByDist: isFilteredByDist,
            isFilteredBySus: isFilteredBySus,
            isFilteredByNew: isFilteredByNew
        )
        let searchedRestaurants = makeSearchedRestaurants(
            restaurants: displayedRestaurants,
            searchText: searchText
        )

        NavigationStack {
            
            //MARK: 餐廳列表
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(searchedRestaurants) { restaurant in
                        NavigationLink(value: restaurant) {
                            RestaurantRowView(restaurant: restaurant)
                        }
                    }
                }
                .padding(.bottom)
            }
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemGroupedBackground))

            //MARK: 無符合篩選條件
            .overlay(
                VStack {
                    if dataStore.hasLoaded && !dataStore.isLoading
                        && searchedRestaurants.isEmpty
                    {
                        EmptyListView(
                            searchText: $searchText,
                            displayedRestaurants: displayedRestaurants,
                            searchedRestaurants: searchedRestaurants,
                            isFilteredByDist: $isFilteredByDist,
                            isFilteredByCity: $isFilteredByCity,
                            isFilteredBySus: $isFilteredBySus,
                            isFilteredByNew: $isFilteredByNew,
                            isSortedByDist: $isSortedByDist
                        )
                    }
                }
            )
            .navigationTitle("米台目")
            //MARK: 關於
            .sheet(isPresented: $showAboutSheet) {
                AboutView()
            }
            //MARK: 篩選
            .sheet(isPresented: $showFilterSheet) {
                FilterSheetView(
                    isSortedByDist: $isSortedByDist,
                    isFilteredByDist: $isFilteredByDist,
                    isFilteredByCity: $isFilteredByCity,
                    isFilteredBySus: $isFilteredBySus,
                    isFilteredByNew: $isFilteredByNew,
                    isPresented: $showFilterSheet
                )
                .presentationDetents([.fraction(0.68)])
                .presentationDragIndicator(.hidden)
                .presentationBackground(.thinMaterial)
            }
            //MARK: toolbar
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    HStack(spacing: 6) {
                        Button {
                            showAboutSheet.toggle()
                        } label: {
                            Image(systemName: "info")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.blue)
                                .padding(8)
                                .background(Color(UIColor.systemGray5))
                                .clipShape(Circle())
                        }
                        Button {
                            showFilterSheet = true
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(
                                    isFilteredByDist.contains(true)
                                        || isFilteredByCity.contains(true)
                                        || isFilteredBySus || isFilteredByNew
                                        ? .launchScreenBackground : .blue
                                )
                                .padding(8)
                                .background(
                                    isFilteredByDist.contains(true)
                                        || isFilteredByCity.contains(true)
                                        || isFilteredBySus || isFilteredByNew
                                        ? .blue : Color(UIColor.systemGray5)
                                )
                                .clipShape(Circle())
                        }
                    }
                }
            }
            .navigationDestination(for: Restaurant.self) { restaurant in
                DetailedSheetView(restaurant: restaurant)
            }
        }
        .searchable(text: $searchText, prompt: "搜尋餐廳、城市、類型")
        .scrollDismissesKeyboard(.immediately)
        .task {
            if !hasLoaded {
                hasLoaded = true
                await dataStore.loadIfNeeded()
                migrateLegacyStatesIfNeeded()
            }
        }
        .overlay {
            let needsInitialLoad =
                !dataStore.hasLoaded && dataStore.restaurants.isEmpty
            if (dataStore.isLoading || needsInitialLoad)
                && displayedRestaurants.isEmpty
            {
                ProgressView("載入資料中…")
            }
        }
        .alert(
            "載入失敗",
            isPresented: Binding(
                get: { dataStore.loadError != nil },
                set: { _ in dataStore.loadError = nil }
            )
        ) {
            Button("確定", role: .cancel) {}
        } message: {
            Text(dataStore.loadError ?? "未知錯誤")
        }
    }

    private func migrateLegacyStatesIfNeeded() {
        guard !didMigrateLegacyStates else { return }
        let restaurants = dataStore.restaurants
        guard !restaurants.isEmpty else { return }
        let nameToId = Dictionary(
            restaurants.map { ($0.Name, $0.id) },
            uniquingKeysWith: { first, _ in first }
        )
        let descriptor = FetchDescriptor<RestaurantState>()
        guard let existingStates = try? modelContext.fetch(descriptor) else {
            return
        }
        let statesByKey = Dictionary(
            grouping: existingStates,
            by: { $0.restaurantKey }
        )
        for state in existingStates {
            guard let newId = nameToId[state.restaurantKey],
                  newId != state.restaurantKey else { continue }
            if let existing = statesByKey[newId]?.first {
                existing.isVisited = existing.isVisited || state.isVisited
                existing.isFavorite = existing.isFavorite || state.isFavorite
                modelContext.delete(state)
            } else {
                state.restaurantKey = newId
            }
        }
        didMigrateLegacyStates = true
    }
}

#Preview {
    ContentView()
        .environmentObject(MichelinDataStore())
        .modelContainer(for: RestaurantState.self, inMemory: true)
}
