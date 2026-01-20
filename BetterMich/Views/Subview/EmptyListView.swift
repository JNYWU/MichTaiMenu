import SwiftUI

struct EmptyListView: View {
    
    @Binding var searchText: String
    
    @Binding var Restaurants: [Restaurant]
    @Binding var displayedRestaurants: [Restaurant]
    var searchedRestaurants: [Restaurant]
        
    @Binding var isFilteredByDist: [Bool]
    @Binding var isFilteredByCity: [Bool]
    @Binding var isFilteredBySus: Bool
    @Binding var isFilteredByNew: Bool
    
    @Binding var isSortedByDist: Bool
    
    let distList = ["三星", "二星", "一星", "必比登", "推薦"]
    let cityList = ["台北", "新北", "台中", "台南", "高雄", "新竹"]
    
    var body: some View {
        
        VStack(spacing: 5) {
            // empty list with only filter, no searching
            if searchText.isEmpty && displayedRestaurants.isEmpty {
                Text("沒有餐廳符合篩選條件：")
            }
                
            if searchText.isEmpty && displayedRestaurants.isEmpty || !searchText.isEmpty && searchedRestaurants.isEmpty {
                HStack {
                    if isFilteredByCity.contains(true) {
                        Text("位於")
                        
                        // show filtered cities
                        ForEach(0 ..< cityList.count) { city in
                            if city < isFilteredByCity.count, isFilteredByCity[city] {
                                FilterLabelView(filterLabel: cityList[city], labelColor: .teal, isFiltered: true)
                            }
                        }
                        
                    if isFilteredByDist.contains(true) || isFilteredBySus || isFilteredByNew {
                            Text("的")
                        }
                    }
                    
                    // show filtered distinction
                    ForEach(0 ..< distList.count) { dist in
                        if dist < isFilteredByDist.count, isFilteredByDist[dist] {
                            FilterLabelView(filterLabel: distList[dist], labelColor: .red, isFiltered: true)
                        }
                    }
                    
                    if isFilteredBySus {
                        FilterLabelView(filterLabel: "綠星", labelColor: .green, isFiltered: true)
                    }
                    if isFilteredByNew {
                        FilterLabelView(filterLabel: "新入選", labelColor: .red, isFiltered: true)
                    }
                }
                
            }
                            
            
            // empty list with searching, and maybe also filter
            if !searchText.isEmpty && searchedRestaurants.isEmpty {
                
                Text("篩選條件下")
          
                // show searched text
                Text("沒有餐廳符合搜尋內容：")
                Text(searchText)
                    .font(.headline)
            }
            
            // show reset filter button
            if isFilteredByCity.contains(true) || isFilteredByDist.contains(true) || isFilteredBySus || isFilteredByNew {
                Button(role: .destructive) {
                    
                    displayedRestaurants = sortRestaurants(restaurants: Restaurants, isSortedByDist: isSortedByDist)
                    isFilteredByDist = Array(repeating: false, count: 5)
                    isFilteredByCity = Array(repeating: false, count: 6)
                    isFilteredBySus = false
                    isFilteredByNew = false
                    
                } label: {
                    Text("清除篩選")
                    Image(systemName: "arrow.2.circlepath")
                }
                .padding(.top, 15)
                .buttonStyle(.bordered)

            }
        }
    }
}
