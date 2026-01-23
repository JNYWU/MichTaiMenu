//
//  Restaurant.swift
//  BetterMich
//
//  Created by 吳求元 on 2023/10/12.
//

import Foundation
import SwiftData

struct Restaurant: Hashable, Identifiable {
    var id: Int
    var Name: String
    var Distinction: Int
    var Sustainable: Bool
    var Bibendum: Bool
    var IsNew: Bool
    var City: String
    var RestaurantType: String
    var Phone: String
    var hasPhone: Bool
    var IMG: String
    var Address: String
    var Description: String

    init(id: Int, name: String, distinction: Int, sustainable: Bool, bibendum: Bool, isNew: Bool, city: String, restaurantType: String, phone: String, img: String, address: String, description: String) {
        self.id = id
        self.Name = name
        self.Distinction = distinction
        self.Sustainable = sustainable
        self.Bibendum = bibendum
        self.IsNew = isNew
        self.City = city
        self.RestaurantType = restaurantType
        self.Phone = phone
        self.hasPhone = phone.first == "+"
        self.IMG = img
        self.Address = address
        self.Description = description
    }
    
    init(raw:[String]) {
        self.id = Int(raw[0])!
        self.Name = raw[1]
        
        self.Distinction = Int(raw[2])!
        
        self.Sustainable = raw[3] == "TRUE" ? true : false
        self.Bibendum = raw[4] == "TRUE" ? true : false
        self.IsNew = false
        
        self.City = raw[6]
        self.RestaurantType = raw[8]
        self.Phone = raw[9]
        self.hasPhone = true
        self.IMG = raw[10]
        self.Address = raw[11]
        self.Description = raw[12]
    }
}

@Model
final class RestaurantState {
    @Attribute(.unique) var restaurantKey: String
    var isVisited: Bool
    var isFavorite: Bool

    init(restaurantKey: String, isVisited: Bool = false, isFavorite: Bool = false) {
        self.restaurantKey = restaurantKey
        self.isVisited = isVisited
        self.isFavorite = isFavorite
    }
}
