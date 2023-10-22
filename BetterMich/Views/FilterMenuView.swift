import SwiftUI
import Algorithms

// dropdown menu for Sorting and filtering
struct FilterMenuView: View {
    
    @Binding var restaurants: [Restaurant]
    
    @Binding var searchText: String
    @Binding var isSortedByDist: Bool
    @Binding var isFilteredByDist: [Bool]
    @Binding var isFilteredByCity: [Bool]
    @Binding var isFilteredBySus: Bool
    
    @Binding var sortedRestaurants: [Restaurant]
    @Binding var filteredRestaurants: [Restaurant]
    @Binding var displayedRestaurants: [Restaurant]
    
    
    var body: some View {
        Menu {
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
                    
                    // filter 台北
                    Button {
                        isFilteredByCity[0].toggle()
                        filteredRestaurants = cityFilter(allRestaurants: restaurants, isFilteredByCity: isFilteredByCity, isFilteredByDist: isFilteredByDist)
                        filteredRestaurants = distFilter(allRestaurants: filteredRestaurants, isFilteredByCity: isFilteredByCity, isFilteredByDist: isFilteredByDist)
                        filteredRestaurants = sustainFilter(Restaurants: filteredRestaurants, isFilteredBySus: isFilteredBySus)
                        
                        displayedRestaurants = sortRestaurants(restaurants: filteredRestaurants, isSortedByDist: !isSortedByDist)
                        
                    } label: {
                        Image(systemName: isFilteredByCity[0] ? "checkmark.circle.fill" : "checkmark.circle")
                        Text("台北")
                    }
                    
                    // filter 台中
                    Button {
                        isFilteredByCity[1].toggle()
                        filteredRestaurants = cityFilter(allRestaurants: restaurants, isFilteredByCity: isFilteredByCity, isFilteredByDist: isFilteredByDist)
                        filteredRestaurants = distFilter(allRestaurants: filteredRestaurants, isFilteredByCity: isFilteredByCity, isFilteredByDist: isFilteredByDist)
                        filteredRestaurants = sustainFilter(Restaurants: filteredRestaurants, isFilteredBySus: isFilteredBySus)

                        displayedRestaurants = sortRestaurants(restaurants: filteredRestaurants, isSortedByDist: !isSortedByDist)
                        
                    } label: {
                        Image(systemName: isFilteredByCity[1] ? "checkmark.circle.fill" : "checkmark.circle")
                        Text("台中")
                    }
                    
                    // filter 台南
                    Button {
                        isFilteredByCity[2].toggle()
                        filteredRestaurants = cityFilter(allRestaurants: restaurants, isFilteredByCity: isFilteredByCity, isFilteredByDist: isFilteredByDist)
                        filteredRestaurants = distFilter(allRestaurants: filteredRestaurants, isFilteredByCity: isFilteredByCity, isFilteredByDist: isFilteredByDist)
                        filteredRestaurants = sustainFilter(Restaurants: filteredRestaurants, isFilteredBySus: isFilteredBySus)

                        displayedRestaurants = sortRestaurants(restaurants: filteredRestaurants, isSortedByDist: !isSortedByDist)
                        
                    } label: {
                        Image(systemName: isFilteredByCity[2] ? "checkmark.circle.fill" : "checkmark.circle")
                        Text("台南")
                    }
                    
                    
                    // filter 高雄
                    Button {
                        isFilteredByCity[3].toggle()
                        filteredRestaurants = cityFilter(allRestaurants: restaurants, isFilteredByCity: isFilteredByCity, isFilteredByDist: isFilteredByDist)
                        filteredRestaurants = distFilter(allRestaurants: filteredRestaurants, isFilteredByCity: isFilteredByCity, isFilteredByDist: isFilteredByDist)
                        filteredRestaurants = sustainFilter(Restaurants: filteredRestaurants, isFilteredBySus: isFilteredBySus)

                        displayedRestaurants = sortRestaurants(restaurants: filteredRestaurants, isSortedByDist: !isSortedByDist)
                        
                    } label: {
                        Image(systemName: isFilteredByCity[3] ? "checkmark.circle.fill" : "checkmark.circle")
                        Text("高雄")
                    }
                    
                } label: {
                    Text("城市")
                    Image(systemName: isFilteredByCity.contains(true) ? "building.2.fill" : "building.2")
                }
                
                
                //MARK: Distinction Filter Submenu
                Menu {
                    
                    // filter 3 star3
                    Button {
                        
                        isFilteredByDist[3].toggle()
                        filteredRestaurants = distFilter(allRestaurants: restaurants, isFilteredByCity: isFilteredByCity, isFilteredByDist: isFilteredByDist)
                        filteredRestaurants = cityFilter(allRestaurants: filteredRestaurants, isFilteredByCity: isFilteredByCity, isFilteredByDist: isFilteredByDist)
                        filteredRestaurants = sustainFilter(Restaurants: filteredRestaurants, isFilteredBySus: isFilteredBySus)

                        displayedRestaurants = sortRestaurants(restaurants: filteredRestaurants, isSortedByDist: !isSortedByDist)
                        
                    } label: {
                        Image(systemName: isFilteredByDist[3] ? "checkmark.circle.fill" : "checkmark.circle")
                        Text("三星")
                        
                    }
                    
                    
                    // filter 2 stars
                    Button {
                        isFilteredByDist[2].toggle()
                        filteredRestaurants = distFilter(allRestaurants: restaurants, isFilteredByCity: isFilteredByCity, isFilteredByDist: isFilteredByDist)
                        filteredRestaurants = cityFilter(allRestaurants: filteredRestaurants, isFilteredByCity: isFilteredByCity, isFilteredByDist: isFilteredByDist)
                        filteredRestaurants = sustainFilter(Restaurants: filteredRestaurants, isFilteredBySus: isFilteredBySus)

                        displayedRestaurants = sortRestaurants(restaurants: filteredRestaurants, isSortedByDist: !isSortedByDist)
                        
                    } label: {
                        Image(systemName: isFilteredByDist[2] ? "checkmark.circle.fill" : "checkmark.circle")
                        Text("二星")
                    }
                    
                    
                    // filter 1 star
                    Button {
                        
                        isFilteredByDist[1].toggle()
                        filteredRestaurants = distFilter(allRestaurants: restaurants, isFilteredByCity: isFilteredByCity, isFilteredByDist: isFilteredByDist)
                        filteredRestaurants = cityFilter(allRestaurants: filteredRestaurants, isFilteredByCity: isFilteredByCity, isFilteredByDist: isFilteredByDist)
                        filteredRestaurants = sustainFilter(Restaurants: filteredRestaurants, isFilteredBySus: isFilteredBySus)

                        displayedRestaurants = sortRestaurants(restaurants: filteredRestaurants, isSortedByDist: !isSortedByDist)
                        
                    } label: {
                        Image(systemName: isFilteredByDist[1] ? "checkmark.circle.fill" : "checkmark.circle")
                        Text("一星")
                    }
                    
                    // filter bibendum
                    Button {
                        
                        isFilteredByDist[0].toggle()
                        filteredRestaurants = distFilter(allRestaurants: restaurants, isFilteredByCity: isFilteredByCity, isFilteredByDist: isFilteredByDist)
                        filteredRestaurants = cityFilter(allRestaurants: filteredRestaurants, isFilteredByCity: isFilteredByCity, isFilteredByDist: isFilteredByDist)
                        filteredRestaurants = sustainFilter(Restaurants: filteredRestaurants, isFilteredBySus: isFilteredBySus)

                        displayedRestaurants = sortRestaurants(restaurants: filteredRestaurants, isSortedByDist: !isSortedByDist)
                        
                    } label: {
                        Image(systemName: isFilteredByDist[0] ? "checkmark.circle.fill" : "checkmark.circle")
                        Text("必比登")
                    }
                    
                    // filter recommend
                    Button {
                        
                        isFilteredByDist[4].toggle()
                        filteredRestaurants = distFilter(allRestaurants: restaurants, isFilteredByCity: isFilteredByCity, isFilteredByDist: isFilteredByDist)
                        filteredRestaurants = cityFilter(allRestaurants: filteredRestaurants, isFilteredByCity: isFilteredByCity, isFilteredByDist: isFilteredByDist)
                        filteredRestaurants = sustainFilter(Restaurants: filteredRestaurants, isFilteredBySus: isFilteredBySus)

                        displayedRestaurants = sortRestaurants(restaurants: filteredRestaurants, isSortedByDist: !isSortedByDist)
                        
                    } label: {
                        Image(systemName: isFilteredByDist[4] ? "checkmark.circle.fill" : "checkmark.circle")
                        Text("推薦")
                    }
                    
                } label: {
                    Text("評鑑等級")
                    Image(systemName: isFilteredByDist.contains(true) ? "star.bubble.fill" : "star.bubble")
                }
                
                
                
                // filter green star
                Button {
                    
                    isFilteredBySus.toggle()
                    filteredRestaurants = distFilter(allRestaurants: restaurants, isFilteredByCity: isFilteredByCity, isFilteredByDist: isFilteredByDist)
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
                
                displayedRestaurants = restaurants
                isFilteredByDist = Array(repeating: false, count: 6)
                isFilteredByCity = Array(repeating: false, count: 4)
                isSortedByDist = true
                
            } label: {
                Image(systemName: "arrow.2.circlepath")
                Text("清除篩選")
            }
            
        } label: {
            Image(systemName: isFilteredByDist.contains(true) ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
        }
    }
}

// function for sorting restaurants
private func sortRestaurants(restaurants: [Restaurant], isSortedByDist: Bool) -> [Restaurant] {
    
    if !isSortedByDist {
        return restaurants.sorted { (restaurant1, restaurant2) -> Bool in
            
            // when distinction is 0, sort by plate and bibendum
            if restaurant1.Distinction == 0 && restaurant2.Distinction == 0 {
                return restaurant1.Bibendum && !restaurant2.Bibendum
            } else {
                return restaurant1.Distinction > restaurant2.Distinction
            }
        }
        
    } else {
        
       return restaurants.sorted { (restaurant1, restaurant2) -> Bool in
           
            if restaurant1.Distinction == 0 && restaurant2.Distinction == 0 {
                return !restaurant1.Bibendum && restaurant2.Bibendum
            } else {
                return restaurant1.Distinction < restaurant2.Distinction
            }
        }
    }
}

// function to filter with cities
private func cityFilter(allRestaurants: [Restaurant], isFilteredByCity: [Bool], isFilteredByDist: [Bool]) -> [Restaurant] {
    
    var outputList: [Restaurant] = []
    
    for filterOption in 0...3 {
        if isFilteredByCity[filterOption] {
            switch filterOption {
            case 0:
                outputList += allRestaurants.filter({ $0.City == "台北" })
            case 1:
                outputList += allRestaurants.filter({ $0.City == "台中" })
            case 2:
                outputList += allRestaurants.filter({ $0.City == "台南" })
            default:
                outputList += allRestaurants.filter({ $0.City == "高雄" })
            }
        }
    }
    
    if !isFilteredByCity.contains(true) {
        return allRestaurants
    }
    
    outputList = Array(outputList.uniqued())
    
    return outputList
    
}

// function to filter with distinctions
private func distFilter(allRestaurants: [Restaurant], isFilteredByCity: [Bool], isFilteredByDist: [Bool]) -> [Restaurant] {
    
    var outputList: [Restaurant] = []
    
    for filterOption in 0...4 {
        if isFilteredByDist[filterOption] {
            switch filterOption {
            case 0:
                outputList += allRestaurants.filter({ $0.Bibendum == true })

            case 1...3:
                outputList += allRestaurants.filter({ $0.Distinction == filterOption })

            default:
                outputList += allRestaurants.filter({ $0.Distinction == 0 && $0.Bibendum == false })
            }
        }
        
    }
    
    if !isFilteredByDist.contains(true) {
        return allRestaurants
    }
    
    outputList = Array(outputList.uniqued())
    
    return outputList
}

private func sustainFilter(Restaurants: [Restaurant], isFilteredBySus: Bool) -> [Restaurant] {
    
    var outputList: [Restaurant] = []
    
    outputList = Restaurants.filter({ $0.Sustainable == true })
    
    if !isFilteredBySus {
        return Restaurants
    }
    
    return outputList
}
