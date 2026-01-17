//
//  BetterMichApp.swift
//  BetterMich
//
//  Created by 吳求元 on 2023/10/12.
//

import SwiftUI

@main
struct BetterMichApp: App {
    @StateObject private var dataStore = MichelinDataStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataStore)
        }
    }
}
