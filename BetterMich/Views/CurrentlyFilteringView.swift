import SwiftUI

struct CurrentlyFilteringView: View {
    
    @Binding var isFilteredByDist: [Bool]
    @Binding var isFilteredByCity: [Bool]
    @Binding var isFilteredBySus: Bool
    
    let distList = ["三星", "二星", "一星", "必比登", "推薦"]
    let cityList = ["台北", "台中", "台南", "高雄"]
    
    var body: some View {
        VStack(spacing: 3) {
            
                // show filtered cities
                HStack {
                    Text("篩選中：")
                        .padding(.top, 8)

                    ForEach(0 ..< 4) { city in
                        if isFilteredByCity[city] {
                            FilterLabelView(filterLabel: cityList[city], labelColor: .teal)
                                .padding(.top, 8)
                        }
                    }
                }
                // show filtered distinction
                HStack {
                    ForEach(0 ..< 5) { dist in
                        if isFilteredByDist[dist] {
                            FilterLabelView(filterLabel: distList[dist], labelColor: .red)

                        }
                    }
                    
                    if isFilteredBySus {
                        FilterLabelView(filterLabel: "綠星", labelColor: .green)
                    }
                }
            
        }

    }
}
