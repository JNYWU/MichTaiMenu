import SwiftUI

struct CurrentlyFilteringView: View {
    
    @Binding var isFilteredByDist: [Bool]
    @Binding var isFilteredByCity: [Bool]
    @Binding var isFilteredBySus: Bool
    @Binding var isFilteredByNew: Bool
    
    let distList = ["三星", "二星", "一星", "必比登", "推薦"]
    let cityList = ["台北", "台中", "台南", "高雄"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            
                // show filtered cities
                HStack {
                    Text("篩選中：")
                        .padding(.top, 8)

                    ForEach(0 ..< 4) { city in
                        
                        FilterLabelView(
                            filterLabel: cityList[city],
                            labelColor: isFilteredByCity[city] ? .teal : Color(.systemGray5)
                        )
                        .foregroundStyle(isFilteredByCity[city] ? .launchScreenBackground : .primary)
                        .padding(.top, 8)
                        
                    }
                }
                // show filtered distinction
                HStack {
                    ForEach(0 ..< 5) { dist in
                        
                        FilterLabelView(
                            filterLabel: distList[dist],
                            labelColor: isFilteredByDist[dist] ? .red : Color(.systemGray5)
                        )
                        .foregroundStyle(isFilteredByDist[dist] ? .launchScreenBackground : .primary)

                    }
                    
                    FilterLabelView(
                        filterLabel: "綠星",
                        labelColor: isFilteredBySus ? .green : Color(.systemGray5)
                    )
                    .foregroundStyle(isFilteredBySus ? .launchScreenBackground : .primary)
                    
                    FilterLabelView(
                        filterLabel: "新入選",
                        labelColor: isFilteredByNew ? .red : Color(.systemGray5)
                    )
                    .foregroundStyle(isFilteredByNew ? .launchScreenBackground : .primary)
                    
                }
                .padding(.bottom, 8)
        }

    }
}


#Preview {
    CurrentlyFilteringView(
        isFilteredByDist: .constant([true, false, true, false, true]),
        isFilteredByCity: .constant([true, false, true, false]),
        isFilteredBySus: .constant(true),
        isFilteredByNew: .constant(true)
    )
    .frame(maxWidth: .infinity)
    .background(.gray)
//                            .adaptiveGlass(cornerRadius: 18)
    .cornerRadius(18)
    .padding(.horizontal, 16)
    .padding(.bottom, 8)
}

