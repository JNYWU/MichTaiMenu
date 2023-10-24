//
//  EmptyListView.swift
//  BetterMich
//
//  Created by 吳求元 on 2023/10/24.
//

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
            if searchText.isEmpty && displayedRestaurants.isEmpty {
                Text("沒有餐廳符合篩選條件：")
                
                HStack {
                    if isFilteredByCity.contains(true) {
                        Text("位於")
                        
                        ForEach(0 ..< 3) { city in
                            if isFilteredByCity[city] {
                                Text(cityList[city])
                                    .foregroundStyle(.teal)
                            }
                        }
                        
                        Text("的")
                    }
                    
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
            
            if !searchText.isEmpty && searchedRestaurants.isEmpty {
                
                HStack {
                    if isFilteredByCity.contains(true) || isFilteredByDist.contains(true) || isFilteredBySus {
                        if isFilteredByCity.contains(true) {
                            Text("位於")
                            
                            ForEach(0 ..< 3) { city in
                                if isFilteredByCity[city] {
                                    Text(cityList[city])
                                        .foregroundStyle(.teal)
                                }
                            }
                            
                            Text("的")
                        }
                        
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
                
                Text("沒有餐廳符合搜尋內容：")
                Text(searchText)
            }
            
        }
    }
}

