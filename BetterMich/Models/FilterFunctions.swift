import SwiftUI
import Algorithms

// function for sorting restaurants
func sortRestaurants(restaurants: [Restaurant], isSortedByDist: Bool) -> [Restaurant] {
    
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
           
            // reverse sort
            if restaurant1.Distinction == 0 && restaurant2.Distinction == 0 {
                return !restaurant1.Bibendum && restaurant2.Bibendum
            } else {
                return restaurant1.Distinction < restaurant2.Distinction
            }
        }
    }
}

// function to filter with cities
func cityFilter(allRestaurants: [Restaurant], isFilteredByCity: [Bool], isFilteredByDist: [Bool]) -> [Restaurant] {
    
    var outputList: [Restaurant] = []
    let cityList = ["台北", "新北", "台中", "台南", "高雄", "新竹"]
    
    for (index, city) in cityList.enumerated() {
        if index < isFilteredByCity.count, isFilteredByCity[index] {
            outputList += allRestaurants.filter({ $0.City == city })
        }
    }
    
    if !isFilteredByCity.contains(true) {
        return allRestaurants
    }
    
    outputList = Array(outputList.uniqued())
    
    return outputList
    
}

// function to filter with distinctions
func distFilter(allRestaurants: [Restaurant], isFilteredByCity: [Bool], isFilteredByDist: [Bool]) -> [Restaurant] {
    
    var outputList: [Restaurant] = []
    
    for filterOption in 0...4 {
        if isFilteredByDist[filterOption] {
            switch filterOption {
                
            // filter 3 stars
            case 0:
                outputList += allRestaurants.filter({ $0.Distinction == 3})
               
            // filter 2 stars
            case 1:
                outputList += allRestaurants.filter({ $0.Distinction == 2})
               
            // filter 1 star
            case 2:
                outputList += allRestaurants.filter({ $0.Distinction == 1})
              
            // filter Bibendum
            case 3:
                outputList += allRestaurants.filter({ $0.Bibendum == true })

            // filter Plate
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

// function to filter Sustainable
func sustainFilter(Restaurants: [Restaurant], isFilteredBySus: Bool) -> [Restaurant] {
    
    var outputList: [Restaurant] = []
    
    outputList = Restaurants.filter({ $0.Sustainable == true })
    
    if !isFilteredBySus {
        return Restaurants
    }
    
    return outputList
}

// function to filter New
func newFilter(Restaurants: [Restaurant], isFilteredByNew: Bool) -> [Restaurant] {
    
    let outputList = Restaurants.filter({ $0.IsNew == true })
    
    if !isFilteredByNew {
        return Restaurants
    }
    
    return outputList
}
