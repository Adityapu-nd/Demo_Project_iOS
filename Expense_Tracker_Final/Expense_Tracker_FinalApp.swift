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
    @AppStorage("ftux") private var ftux: Bool = true
    var body: some Scene {
        WindowGroup {
            if ftux {
                NewUserScreen()
            } else {
                Dashboard()
            }
        }
    }
}
