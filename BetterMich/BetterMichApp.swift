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
        let isPreview =
            ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"]
            == "1"
        let config = ModelConfiguration(
            "RestaurantState-v2",
            schema: schema,
            isStoredInMemoryOnly: isPreview
        )
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            if isPreview {
                // Avoid crashing previews if persistent store cannot be loaded.
                return try! ModelContainer(
                    for: schema,
                    configurations: [
                        ModelConfiguration(
                            schema: schema,
                            isStoredInMemoryOnly: true
                        )
                    ]
                )
            }
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
