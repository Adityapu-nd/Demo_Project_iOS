//
//  Expense_Tracker_FinalApp.swift
//  Expense_Tracker_Final
//
//  Created by Aditya Pundlik on 09/02/26.
//

import SwiftUI
import SwiftData

@main
struct Expense_Tracker_FinalApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
