//
//  Expense_TrackerApp.swift
//  Expense Tracker
//
//  Created by Aditya Pundlik on 28/01/26.
//

import SwiftUI
import SwiftData

@main
struct Expense_TrackerApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Expense.self])
        }
    }
}
