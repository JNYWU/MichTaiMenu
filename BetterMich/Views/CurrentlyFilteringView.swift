//
//  CurrentlyFilteringView.swift
//  BetterMich
//
//  Created by 吳求元 on 2023/10/24.
//

import SwiftUI

struct CurrentlyFilteringView: View {
    
    @Binding var isFilteredByDist: [Bool]
    @Binding var isFilteredByCity: [Bool]
    @Binding var isFilteredBySus: Bool
    
    let distList = ["三星", "二星", "一星", "必比登", "推薦"]
    let cityList = ["台北", "台中", "台南", "高雄"]
    
    var body: some View {
        VStack(spacing: 3) {
            
            Text("篩選中：")
                // show filtered cities
                HStack {
                    ForEach(0 ..< 3) { city in
                        if isFilteredByCity[city] {
                            Text(cityList[city])
                                .foregroundStyle(.teal)
                        }
                    }
                }
                // show filtered distinction
                HStack {
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
            
        .padding(10)
        .background(.regularMaterial)
        .cornerRadius(10)
        .padding(10)
    }
}
