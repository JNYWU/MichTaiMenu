import SwiftUI

struct EmptyListView: View {
    
    @Binding var searchText: String
    
    @Binding var Restaurants: [Restaurant]
    @Binding var displayedRestaurants: [Restaurant]
    var searchedRestaurants: [Restaurant]
        
    @Binding var isFilteredByDist: [Bool]
    @Binding var isFilteredByCity: [Bool]
    @Binding var isFilteredBySus: Bool
    
    @Binding var isSortedByDist: Bool
    
    let distList = ["三星", "二星", "一星", "必比登", "推薦"]
    let cityList = ["台北", "台中", "台南", "高雄"]
    
    var body: some View {
        
        VStack(spacing: 5) {
            // empty list with only filter, no searching
            if searchText.isEmpty && displayedRestaurants.isEmpty {
                Text("沒有餐廳符合篩選條件：")
                
                HStack {
                    if isFilteredByCity.contains(true) {
                        Text("位於")
                        
                        // show filtered cities
                        ForEach(0 ..< 3) { city in
                            if isFilteredByCity[city] {
                                FilterLabelView(filterLabel: cityList[city], labelColor: .teal)
                            }
                        }
                        
                        if isFilteredByDist.contains(true) || isFilteredBySus {
                            Text("的")
                        }
                    }
                    
                    // show filtered distinction
                    ForEach(0 ..< 4) { dist in
                        if isFilteredByDist[dist] {
                            FilterLabelView(filterLabel: distList[dist], labelColor: .red)
                        }
                    }
                    
                    if isFilteredBySus {
                        FilterLabelView(filterLabel: "綠星", labelColor: .green)
                    }
                }
                
            }
            
            // empty list with searching, and maybe also filter
            if !searchText.isEmpty && searchedRestaurants.isEmpty {
                
                HStack {
                    // if filtered with any filter option
                    if isFilteredByCity.contains(true) || isFilteredByDist.contains(true) || isFilteredBySus {
                        if isFilteredByCity.contains(true) {
                            Text("位於")
                            
                            // show filtered cities
                            ForEach(0 ..< 3) { city in
                                if isFilteredByCity[city] {
                                    FilterLabelView(filterLabel: cityList[city], labelColor: .teal)

                                }
                            }
                            
                            if isFilteredByDist.contains(true) || isFilteredBySus {
                                Text("的")
                            }                        }
                        
                        // show filtered distinction
                        ForEach(0 ..< 4) { dist in
                            if isFilteredByDist[dist] {
                                FilterLabelView(filterLabel: distList[dist], labelColor: .red)
                            }
                        }
                        
                        if isFilteredBySus {
                            FilterLabelView(filterLabel: "綠星", labelColor: .green)
                        }
                        
                        Text("篩選條件下")
                    }
                    
                }
                
                // show searched text
                Text("沒有餐廳符合搜尋內容：")
                Text(searchText)
                    .font(.headline)
            }
            
            // show reset filter button
            if isFilteredByCity.contains(true) || isFilteredByDist.contains(true) || isFilteredBySus {
                Button(role: .destructive) {
                    
                    displayedRestaurants = sortRestaurants(restaurants: Restaurants, isSortedByDist: !isSortedByDist)
                    isFilteredByDist = Array(repeating: false, count: 5)
                    isFilteredByCity = Array(repeating: false, count: 4)
                    isFilteredBySus = false
                    
                } label: {
                    Text("清除篩選")
                    Image(systemName: "arrow.2.circlepath")
                }
                .padding(.top, 15)
            }
        }
    }
}

