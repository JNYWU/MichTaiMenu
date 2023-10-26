import SwiftUI

struct FilterMenuButtonView: View {
    
    @Binding var isSortedByDist: Bool
    @Binding var isFilteredByCity: [Bool]
    @Binding var isFilteredByDist: [Bool]
    
    @Binding var isFilteredBySus: Bool
    @Binding var filteredRestaurants: [Restaurant]
    @Binding var restaurants: [Restaurant]
    @Binding var displayedRestaurants: [Restaurant]
    
    var filterCity: Bool
    var filterOption: Int
    
    let distList = ["三星", "二星", "一星", "必比登", "推薦"]
    let cityList = ["台北", "台中", "台南", "高雄"]
    
    var body: some View {
        Button {
            if filterCity {
                isFilteredByCity[filterOption].toggle()
            } else {
                isFilteredByDist[filterOption].toggle()
            }
            
            filteredRestaurants = cityFilter(allRestaurants: restaurants, isFilteredByCity: isFilteredByCity, isFilteredByDist: isFilteredByDist)
            filteredRestaurants = distFilter(allRestaurants: filteredRestaurants, isFilteredByCity: isFilteredByCity, isFilteredByDist: isFilteredByDist)
            filteredRestaurants = sustainFilter(Restaurants: filteredRestaurants, isFilteredBySus: isFilteredBySus)
            
            displayedRestaurants = sortRestaurants(restaurants: filteredRestaurants, isSortedByDist: !isSortedByDist)
            
        } label: {
            
            if filterCity {
                Image(systemName: isFilteredByCity[filterOption] ? "checkmark.circle.fill" : "checkmark.circle")
                Text(cityList[filterOption])
            } else {
                Image(systemName: isFilteredByDist[filterOption] ? "checkmark.circle.fill" : "checkmark.circle")
                Text(distList[filterOption])
            }
            
        }
    }

}
