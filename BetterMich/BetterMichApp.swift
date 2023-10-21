//
//  BetterMichApp.swift
//  BetterMich
//
//  Created by 吳求元 on 2023/10/12.
//

import SwiftUI

@main
struct BetterMichApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(Restaurants: loadCSVData(), displayedRestaurants: loadCSVData())
        }
    }
}
