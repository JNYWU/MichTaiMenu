import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var dataStore: MichelinDataStore
    
    @State var searchText = ""
    @State var isSortedByDist = false
    @State var isFilteredByDist = Array(repeating: false, count: 5)
    @State var isFilteredByCity = Array(repeating: false, count: 6)
    @State var isFilteredBySus = false
    @State var isFilteredByNew = false
    @State var showAboutSheet = false
    @State private var showFilterSheet = false
    
    @State var sortedRestaurants: [Restaurant] = []
    @State var filteredRestaurants: [Restaurant] = []
    @State private var displayedRestaurants: [Restaurant] = []

    @State private var hasLoaded = false
    @State private var searchResults: [Restaurant] = []
    
    var body: some View {
        
        NavigationStack {
            
            // ZStack for showing current filters
            ZStack(alignment: .bottom) {
                
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(searchText.isEmpty ? displayedRestaurants : searchResults) { restaurant in
                            NavigationLink(value: restaurant) {
                                RestaurantRowView(restaurant: restaurant)
                            }
                        }
                    }
                    .padding(.bottom)
                }
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.systemGroupedBackground))
                
                // show empty list view
                .overlay(
                    VStack {
                        if dataStore.hasLoaded && !dataStore.isLoading
                            && (displayedRestaurants.isEmpty || searchResults.isEmpty) {
                            EmptyListView(searchText: $searchText, Restaurants: $dataStore.restaurants, displayedRestaurants: $displayedRestaurants,  searchedRestaurants: searchResults, isFilteredByDist: $isFilteredByDist, isFilteredByCity: $isFilteredByCity, isFilteredBySus: $isFilteredBySus, isFilteredByNew: $isFilteredByNew, isSortedByDist: $isSortedByDist)
                        }
                    }
                )
            }
            .navigationTitle("米台目")
            .sheet(isPresented: $showAboutSheet) {
                AboutView()
            }
            .sheet(isPresented: $showFilterSheet) {
                FilterSheetView(
                    Restaurants: $dataStore.restaurants,
                    isSortedByDist: $isSortedByDist,
                    isFilteredByDist: $isFilteredByDist,
                    isFilteredByCity: $isFilteredByCity,
                    isFilteredBySus: $isFilteredBySus,
                    isFilteredByNew: $isFilteredByNew,
                    sortedRestaurants: $sortedRestaurants,
                    filteredRestaurants: $filteredRestaurants,
                    displayedRestaurants: $displayedRestaurants,
                    isPresented: $showFilterSheet
                )
                .presentationDetents([.fraction(0.68)])
                .presentationDragIndicator(.hidden)
                .presentationBackground(.thinMaterial)
            }
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
                                .foregroundStyle(isFilteredByDist.contains(true) || isFilteredByCity.contains(true) || isFilteredBySus || isFilteredByNew ? .launchScreenBackground : .blue)
                                .padding(8)
                                .background(isFilteredByDist.contains(true) || isFilteredByCity.contains(true) || isFilteredBySus || isFilteredByNew ? .blue : Color(UIColor.systemGray5))
                                .clipShape(Circle())
                        }
                    }
                }
                ToolbarItemGroup(placement: .topBarLeading) {
                    // Removed CurrentlyFilteringView and reset button here as per instructions
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
                displayedRestaurants = sortRestaurants(restaurants: dataStore.restaurants, isSortedByDist: isSortedByDist)
                updateSearchResults()
            }
        }
        .onChange(of: dataStore.restaurants) { _, newValue in
            if displayedRestaurants.isEmpty && !newValue.isEmpty {
                displayedRestaurants = sortRestaurants(restaurants: newValue, isSortedByDist: isSortedByDist)
            }
            updateSearchResults()
        }
        .onChange(of: searchText) { _, _ in
            updateSearchResults()
        }
        .onChange(of: displayedRestaurants) { _, _ in
            updateSearchResults()
        }
        .overlay {
            let needsInitialLoad = !dataStore.hasLoaded && dataStore.restaurants.isEmpty
            if (dataStore.isLoading || needsInitialLoad) && displayedRestaurants.isEmpty {
                ProgressView("載入資料中…")
            }
        }
        .alert("載入失敗", isPresented: Binding(get: { dataStore.loadError != nil }, set: { _ in dataStore.loadError = nil })) {
            Button("確定", role: .cancel) {}
        } message: {
            Text(dataStore.loadError ?? "未知錯誤")
        }
    }

    private func updateSearchResults() {
        if searchText.isEmpty {
            searchResults = displayedRestaurants
            return
        }
        let keyword = searchText
        searchResults = displayedRestaurants.filter { restaurant in
            let nameMatch = restaurant.Name.localizedCaseInsensitiveContains(keyword)
            let cityMatch = restaurant.City.localizedCaseInsensitiveContains(keyword)
            let typeMatch = restaurant.RestaurantType.localizedCaseInsensitiveContains(keyword)
            return nameMatch || cityMatch || typeMatch
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(MichelinDataStore())
}

fileprivate extension View {
    @ViewBuilder
    func adaptiveGlass(cornerRadius: CGFloat) -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
        } else {
            self.background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
        }
    }
}

