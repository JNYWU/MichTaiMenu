//
//  Restaurant.swift
//  BetterMich
//
//  Created by 吳求元 on 2023/10/12.
//

import Foundation

struct Restaurant: Hashable, Identifiable {
    var id: Int
    var Name: String
    var Distinction: Int
    var Sustainable: Bool
    var Bibendum: Bool
    var City: String
    var RestaurantType: String
    var Phone: String
    var hasPhone: Bool
    var IMG: String
    var Address: String
    
    init(raw:[String]) {
        self.id = Int(raw[0])!
        self.Name = raw[1]
        
        self.Distinction = Int(raw[2])!
        
        self.Sustainable = raw[3] == "TRUE" ? true : false
        self.Bibendum = raw[4] == "TRUE" ? true : false
        
        self.City = raw[6]
        self.RestaurantType = raw[8]
        self.Phone = raw[9]
        self.hasPhone = true
        self.IMG = raw[10]
        self.Address = String(raw[11].dropFirst())
    }
}
