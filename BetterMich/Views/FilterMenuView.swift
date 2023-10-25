import SwiftUI
import Algorithms

// dropdown menu for Sorting and filtering
struct FilterMenuView: View {
    
    @Binding var Restaurants: [Restaurant]
    
    @Binding var searchText: String
    @Binding var isSortedByDist: Bool
    @Binding var isFilteredByDist: [Bool]
    @Binding var isFilteredByCity: [Bool]
    @Binding var isFilteredBySus: Bool
    @Binding var showAboutSheet: Bool
    
    @Binding var sortedRestaurants: [Restaurant]
    @Binding var filteredRestaurants: [Restaurant]
    @Binding var displayedRestaurants: [Restaurant]
    
    
    var body: some View {
        Menu {
            
            Section("資訊") {
                Button {
                    showAboutSheet = true
                } label: {
                    Image(systemName: "info.circle")
                    Text("關於米台目")
                }
            }
            
            Section("排序") {
                
                // sort by distinction
                Button {
                        
                    sortedRestaurants = sortRestaurants(restaurants: displayedRestaurants, isSortedByDist: isSortedByDist)
                        
                    displayedRestaurants = sortedRestaurants
                    isSortedByDist.toggle()
                    
                } label: {
                    Image(systemName: isSortedByDist ? "arrowshape.down.fill" : "arrowshape.up.fill")
                    Text("評鑑等級")
                }

            }
            
            Section("篩選") {
                
                //MARK: City Filter Submenu
                Menu {
                    
                    ForEach(0 ..< 4) { filterOption in
                        FilterMenuButtonView(isSortedByDist: $isSortedByDist, isFilteredByCity: $isFilteredByCity, isFilteredByDist: $isFilteredByDist, isFilteredBySus: $isFilteredBySus, filteredRestaurants: $filteredRestaurants, restaurants: $Restaurants, displayedRestaurants: $displayedRestaurants, filterCity: true, filterOption: filterOption)
                    }
 
                } label: {
                    Text("城市")
                    Image(systemName: isFilteredByCity.contains(true) ? "building.2.fill" : "building.2")
                }
                
                
                //MARK: Distinction Filter Submenu
                Menu {
                    
                    ForEach(0 ..< 5) { filterOption in
                        FilterMenuButtonView(isSortedByDist: $isSortedByDist, isFilteredByCity: $isFilteredByCity, isFilteredByDist: $isFilteredByDist, isFilteredBySus: $isFilteredBySus, filteredRestaurants: $filteredRestaurants, restaurants: $Restaurants, displayedRestaurants: $displayedRestaurants, filterCity: false, filterOption: filterOption)
                    }
                    
                } label: {
                    Text("評鑑等級")
                    Image(systemName: isFilteredByDist.contains(true) ? "star.bubble.fill" : "star.bubble")
                }
                
                // filter green star
                Button {
                    
                    isFilteredBySus.toggle()
                    filteredRestaurants = distFilter(allRestaurants: Restaurants, isFilteredByCity: isFilteredByCity, isFilteredByDist: isFilteredByDist)
                    filteredRestaurants = cityFilter(allRestaurants: filteredRestaurants, isFilteredByCity: isFilteredByCity, isFilteredByDist: isFilteredByDist)
                    filteredRestaurants = sustainFilter(Restaurants: filteredRestaurants, isFilteredBySus: isFilteredBySus)

                    displayedRestaurants = sortRestaurants(restaurants: filteredRestaurants, isSortedByDist: !isSortedByDist)
                    
                } label: {
                    Image(systemName: isFilteredBySus ? "leaf.fill" : "leaf")
                    Text("綠星")
                }
                
            }
            
            Divider()
            
            //MARK: Reset Filter Button
            // clear filter and reset restaurant list
            Button(role: .destructive) {
                                
                displayedRestaurants = sortRestaurants(restaurants: Restaurants, isSortedByDist: !isSortedByDist)
                isFilteredByDist = Array(repeating: false, count: 5)
                isFilteredByCity = Array(repeating: false, count: 4)
                isFilteredBySus = false
                
            } label: {
                Image(systemName: "arrow.2.circlepath")
                Text("清除篩選")
            }
            
        } label: {
            // filter menu button label
            Image(systemName: isFilteredByDist.contains(true) || isFilteredByCity.contains(true) || isFilteredBySus ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
        }
    }
}
