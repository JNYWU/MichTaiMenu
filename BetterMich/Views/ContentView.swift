import SwiftUI

struct ContentView: View {
    
    @State var Restaurants: [Restaurant]
    
    @State var searchText = ""
    @State var isSortedByDist: Bool = true
    @State var isFilteredByDist = Array(repeating: false, count: 6)
    @State var isFilteredByCity = Array(repeating: false, count: 4)

    
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
            
            List {
                ForEach (searchText.isEmpty ? displayedRestaurants : searchedRestaurants) { restaurant in
                               
                    RestaurantRowView(restaurant: restaurant)
                    
                }
            }
            .navigationTitle("Michelin")
            
            // reset list when pulled to refresh
            .refreshable {
                displayedRestaurants = Restaurants
                isFilteredByDist = Array(repeating: false, count: 6)
                isFilteredByCity = Array(repeating: false, count: 4)
                isSortedByDist = true
            }
            .toolbar {
                ToolbarItem {
                    FilterMenuView(restaurants: $Restaurants, searchText: $searchText, isSortedByDist: $isSortedByDist, isFilteredByDist: $isFilteredByDist, isFilteredByCity: $isFilteredByCity,sortedRestaurants: $sortedRestaurants, filteredRestaurants: $filteredRestaurants, displayedRestaurants: $displayedRestaurants)
                    
                }
            }
        }
        .searchable(text: $searchText)
        .scrollDismissesKeyboard(.immediately)
    }
    
    
}

#Preview {
    ContentView(Restaurants: loadCSVData(), displayedRestaurants: loadCSVData())
}


