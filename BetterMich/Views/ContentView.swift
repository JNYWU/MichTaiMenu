import SwiftUI

struct ContentView: View {
    
    @State var Restaurants: [Restaurant]
    
    @State var searchText = ""
    @State var isSortedByDist = true
    @State var isFilteredByDist = Array(repeating: false, count: 5)
    @State var isFilteredByCity = Array(repeating: false, count: 4)
    @State var isFilteredBySus = false
    @State var showAboutSheet = false
    @State var selectedRestaurant: Restaurant?
    
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
                
                ScrollView {
                    ForEach (searchText.isEmpty ? displayedRestaurants : searchedRestaurants) { restaurant in
                        Button {
                            selectedRestaurant = restaurant
                        } label: {
                            RestaurantRowView(restaurant: restaurant)
                        }
                    }
                    
                    .sheet(item: $selectedRestaurant) { restaurant in
                        DetailedSheetView(restaurant: restaurant)
                            .presentationDetents([.medium, .large])
                            .presentationDragIndicator(.automatic)
                            .presentationCornerRadius(30)
                            .presentationBackground(.thickMaterial)
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.systemGroupedBackground))
                
                // show empty list view
                .overlay(
                    VStack {
                        if displayedRestaurants.isEmpty || searchedRestaurants.isEmpty {
                            EmptyListView(searchText: $searchText, Restaurants: $Restaurants, displayedRestaurants: $displayedRestaurants,  searchedRestaurants: searchedRestaurants, isFilteredByDist: $isFilteredByDist, isFilteredByCity: $isFilteredByCity, isFilteredBySus: $isFilteredBySus, isSortedByDist: $isSortedByDist)
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
                                displayedRestaurants = sortRestaurants(restaurants: Restaurants, isSortedByDist: !isSortedByDist)
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
                        FilterMenuView(Restaurants: $Restaurants, searchText: $searchText, isSortedByDist: $isSortedByDist, isFilteredByDist: $isFilteredByDist, isFilteredByCity: $isFilteredByCity, isFilteredBySus: $isFilteredBySus, showAboutSheet: $showAboutSheet, sortedRestaurants: $sortedRestaurants, filteredRestaurants: $filteredRestaurants, displayedRestaurants: $displayedRestaurants)
                    }
                }
                ToolbarItemGroup(placement: .topBarLeading) {
                    // Removed CurrentlyFilteringView and reset button here as per instructions
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

