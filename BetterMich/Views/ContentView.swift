import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var dataStore: MichelinDataStore
    
    @State var searchText = ""
    @State var isSortedByDist = false
    @State var isFilteredByDist = Array(repeating: false, count: 5)
    @State var isFilteredByCity = Array(repeating: false, count: 4)
    @State var isFilteredBySus = false
    @State var showAboutSheet = false
    
    @State var sortedRestaurants: [Restaurant] = []
    @State var filteredRestaurants: [Restaurant] = []
    @State private var displayedRestaurants: [Restaurant] = []

    @State private var hasLoaded = false
        
    var searchedRestaurants: [Restaurant] {
        // if search field is empty, return original list
        if searchText.isEmpty {
            return displayedRestaurants
        } else {
            // filter restaurant name, city, and type
            return displayedRestaurants.filter { restaurant in
                let nameMatch = restaurant.Name.localizedCaseInsensitiveContains(searchText)
                let cityMatch = restaurant.City.localizedCaseInsensitiveContains(searchText)
                let typeMatch = restaurant.RestaurantType.localizedCaseInsensitiveContains(searchText)
                return nameMatch || cityMatch || typeMatch
            }
        }
    }
    
    var body: some View {
        
        NavigationStack {
            
            // ZStack for showing current filters
            ZStack(alignment: .bottom) {
                
                ScrollView {
                    ForEach(searchText.isEmpty ? displayedRestaurants : searchedRestaurants) { restaurant in
                        NavigationLink(value: restaurant) {
                            RestaurantRowView(restaurant: restaurant)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.systemGroupedBackground))
                
                // show empty list view
                .overlay(
                    VStack {
                        if dataStore.hasLoaded && !dataStore.isLoading
                            && (displayedRestaurants.isEmpty || searchedRestaurants.isEmpty) {
                            EmptyListView(searchText: $searchText, Restaurants: $dataStore.restaurants, displayedRestaurants: $displayedRestaurants,  searchedRestaurants: searchedRestaurants, isFilteredByDist: $isFilteredByDist, isFilteredByCity: $isFilteredByCity, isFilteredBySus: $isFilteredBySus, isSortedByDist: $isSortedByDist)
                        }
                    }
                )
                
                if (isFilteredByDist.contains(true) || isFilteredByCity.contains(true) || isFilteredBySus)
                    && !displayedRestaurants.isEmpty {
                    VStack {
                        HStack(alignment: .center, spacing: 8) {
                            CurrentlyFilteringView(isFilteredByDist: $isFilteredByDist, isFilteredByCity: $isFilteredByCity, isFilteredBySus: $isFilteredBySus)
                                .contentShape(Rectangle())
                                .onTapGesture {}
                            Button {
                                displayedRestaurants = sortRestaurants(restaurants: dataStore.restaurants, isSortedByDist: isSortedByDist)
                                isFilteredByDist = Array(repeating: false, count: 5)
                                isFilteredByCity = Array(repeating: false, count: 4)
                                isFilteredBySus = false
                            } label: {
                                Image(systemName: "arrow.2.circlepath")
                                    .foregroundStyle(.red)
                                    .imageScale(.medium)
                                    .padding(6)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 2)
                        .adaptiveGlass(cornerRadius: 18)
                        .cornerRadius(18)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                    }
                }
            }
            .navigationTitle("米台目")
            .sheet(isPresented: $showAboutSheet) {
                AboutView()
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
                        FilterMenuView(Restaurants: $dataStore.restaurants, searchText: $searchText, isSortedByDist: $isSortedByDist, isFilteredByDist: $isFilteredByDist, isFilteredByCity: $isFilteredByCity, isFilteredBySus: $isFilteredBySus, showAboutSheet: $showAboutSheet, sortedRestaurants: $sortedRestaurants, filteredRestaurants: $filteredRestaurants, displayedRestaurants: $displayedRestaurants)
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
            }
        }
        .onChange(of: dataStore.restaurants) { _, newValue in
            if displayedRestaurants.isEmpty && !newValue.isEmpty {
                displayedRestaurants = sortRestaurants(restaurants: newValue, isSortedByDist: isSortedByDist)
            }
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

