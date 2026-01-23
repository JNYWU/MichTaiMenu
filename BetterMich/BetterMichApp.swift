//
//  BetterMichApp.swift
//  BetterMich
//
//  Created by 吳求元 on 2023/10/12.
//

import SwiftData
import SwiftUI

@main
struct BetterMichApp: App {
    @StateObject private var dataStore = MichelinDataStore()
    private let modelContainer: ModelContainer = {
        let schema = Schema([RestaurantState.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataStore)
                .modelContainer(modelContainer)
        }
    }
}
