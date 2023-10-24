import SwiftUI

struct EmptyListView: View {
    
    @Binding var searchText: String
    
    @Binding var displayedRestaurants: [Restaurant]
    var searchedRestaurants: [Restaurant]
        
    @Binding var isFilteredByDist: [Bool]
    @Binding var isFilteredByCity: [Bool]
    @Binding var isFilteredBySus: Bool
    
    let distList = ["三星", "二星", "一星", "必比登", "推薦"]
    let cityList = ["台北", "台中", "台南", "高雄"]
    
    var body: some View {
        
        VStack {
            // empty list with only filter, no searching
            if searchText.isEmpty && displayedRestaurants.isEmpty {
                Text("沒有餐廳符合篩選條件：")
                
                HStack {
                    if isFilteredByCity.contains(true) {
                        Text("位於")
                        
                        // show filtered cities
                        ForEach(0 ..< 3) { city in
                            if isFilteredByCity[city] {
                                Text(cityList[city])
                                    .foregroundStyle(.teal)
                            }
                        }
                        
                        Text("的")
                    }
                    
                    // show filtered distinction
                    ForEach(0 ..< 4) { dist in
                        if isFilteredByDist[dist] {
                            Text(distList[dist])
                                .foregroundStyle(.red)
                        }
                    }
                    
                    if isFilteredBySus {
                        Text("綠星")
                            .foregroundStyle(.green)
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
                                    Text(cityList[city])
                                        .foregroundStyle(.teal)
                                }
                            }
                            
                            Text("的")
                        }
                        
                        // show filtered distinction
                        ForEach(0 ..< 4) { dist in
                            if isFilteredByDist[dist] {
                                Text(distList[dist])
                                    .foregroundStyle(.red)
                            }
                        }
                        
                        if isFilteredBySus {
                            Text("綠星")
                                .foregroundStyle(.green)
                        }
                        
                        Text("篩選條件下")
                    }
                    
                }
                
                // show searched text
                Text("沒有餐廳符合搜尋內容：")
                Text(searchText)
            }
            
        }
    }
}

