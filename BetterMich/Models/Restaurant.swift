//
//  Restaurant.swift
//  BetterMich
//
//  Created by 吳求元 on 2023/10/12.
//

import Foundation
import SwiftData

struct Restaurant: Hashable, Identifiable {
    var id: String
    var Name: String
    var Distinction: Int
    var Sustainable: Bool
    var Bibendum: Bool
    var IsNew: Bool
    var City: String
    var RestaurantType: String
    var Phone: String
    var hasPhone: Bool { Phone.first == "+" }
    var IMG: String
    var Address: String
    var Description: String
    var AwardHistory: [AwardHistoryEntry]

    init(
        id: String,
        name: String,
        distinction: Int,
        sustainable: Bool,
        bibendum: Bool,
        isNew: Bool,
        city: String,
        restaurantType: String,
        phone: String,
        img: String,
        address: String,
        description: String,
        awardHistory: [AwardHistoryEntry] = []
    ) {
        self.id = id
        self.Name = name
        self.Distinction = distinction
        self.Sustainable = sustainable
        self.Bibendum = bibendum
        self.IsNew = isNew
        self.City = city
        self.RestaurantType = restaurantType
        self.Phone = phone
        self.IMG = img
        self.Address = address
        self.Description = description
        self.AwardHistory = awardHistory
    }
}

struct AwardHistoryEntry: Hashable {
    let year: String
    let distinction: Int
    let bibendum: Bool
    let sustainable: Bool
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

@MainActor
enum RestaurantStateMutations {
    @discardableResult
    static func toggleVisited(
        restaurantId: String,
        state: RestaurantState?,
        modelContext: ModelContext
    ) -> RestaurantState? {
        if let state {
            state.isVisited.toggle()
            return cleanupIfNeeded(state, modelContext: modelContext)
        } else {
            let state = RestaurantState(
                restaurantKey: restaurantId,
                isVisited: true
            )
            modelContext.insert(state)
            return state
        }
    }

    @discardableResult
    static func toggleFavorite(
        restaurantId: String,
        state: RestaurantState?,
        modelContext: ModelContext
    ) -> RestaurantState? {
        if let state {
            state.isFavorite.toggle()
            return cleanupIfNeeded(state, modelContext: modelContext)
        } else {
            let state = RestaurantState(
                restaurantKey: restaurantId,
                isFavorite: true
            )
            modelContext.insert(state)
            return state
        }
    }

    private static func cleanupIfNeeded(
        _ state: RestaurantState,
        modelContext: ModelContext
    ) -> RestaurantState? {
        if !state.isVisited && !state.isFavorite {
            modelContext.delete(state)
            return nil
        }
        return state
    }
}
