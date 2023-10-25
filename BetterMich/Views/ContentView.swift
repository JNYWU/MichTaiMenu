import SwiftUI

struct ContentView: View {
    
    @State var Restaurants: [Restaurant]
    
    @State var searchText = ""
    @State var isSortedByDist = true
    @State var isFilteredByDist = Array(repeating: false, count: 5)
    @State var isFilteredByCity = Array(repeating: false, count: 4)
    @State var isFilteredBySus = false
    @State var showAboutSheet = false
    
    @State var sortedRestaurants: [Restaurant] = []
    @State var filteredRestaurants: [Restaurant] = []
    @State var displayedRestaurants: [Restaurant]
        
    var searchedRestaurants: [Restaurant] {
        // if search field is empty, return original list
        if searchText.isEmpty {
            return displayedRestaurants
        } else {
            // filter restaurant name, city, and type
            return displayedRestaurants.filter { $0.Name.localizedCaseInsensitiveContains(searchText) || $0.City.localizedCaseInsensitiveContains(searchText) || $0.RestaurantType.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        
        NavigationStack {
            
            // ZStack for showing current filters
            ZStack(alignment: .bottom) {
                
                List {
                    ForEach (searchText.isEmpty ? displayedRestaurants : searchedRestaurants) { restaurant in
                        RestaurantRowView(restaurant: restaurant)
                    }
                    
                }
                // show empty list view
                .overlay(
                    VStack {
                        if displayedRestaurants.isEmpty || searchedRestaurants.isEmpty {
                            EmptyListView(searchText: $searchText, displayedRestaurants: $displayedRestaurants, searchedRestaurants: searchedRestaurants, isFilteredByDist: $isFilteredByDist, isFilteredByCity: $isFilteredByCity, isFilteredBySus: $isFilteredBySus)
                        }
                    }
                )
                .navigationTitle("米台目")
                // show about view
                .sheet(isPresented: $showAboutSheet) {
                    AboutView()
                }
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        // filter menu button
                        FilterMenuView(restaurants: $Restaurants, searchText: $searchText, isSortedByDist: $isSortedByDist, isFilteredByDist: $isFilteredByDist, isFilteredByCity: $isFilteredByCity, isFilteredBySus: $isFilteredBySus, showAboutSheet: $showAboutSheet, sortedRestaurants: $sortedRestaurants, filteredRestaurants: $filteredRestaurants, displayedRestaurants: $displayedRestaurants)
                        
                    }
                    
                    ToolbarItemGroup(placement: .bottomBar) {
                        if isFilteredByDist.contains(true) || isFilteredByCity.contains(true) || isFilteredBySus {
                            CurrentlyFilteringView(isFilteredByDist: $isFilteredByDist, isFilteredByCity: $isFilteredByCity, isFilteredBySus: $isFilteredBySus)
                        }
                    }
                }
                
            }
        }
        .searchable(text: $searchText, prompt: "搜尋餐廳、城市、類型")
        .scrollDismissesKeyboard(.immediately)
    }
    
}

#Preview {
    ContentView(Restaurants: loadCSVData(), displayedRestaurants: loadCSVData())
}


