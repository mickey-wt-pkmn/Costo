//
//  CostoApp.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/20.
//

import SwiftUI
import SwiftData

@main
struct CostoApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Grocery.self,
            History.self,
            UseIngredientHistory.self
        ])
        let isTesting = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: isTesting)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(sharedModelContainer)
    }
}
