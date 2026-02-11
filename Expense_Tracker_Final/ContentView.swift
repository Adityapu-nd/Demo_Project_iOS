//
//  ContentView.swift
//  Expense Tracker
//
//  Created by Aditya Pundlik on 28/01/26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("FirstTimeUser") private var firstTimeUser: Bool = true

    var body: some View {
        Group {
            if UserDefaults.standard.object(forKey: "FirstTimeUser") != nil && firstTimeUser == false {
                Dashboard()
            } else {
                NewUserScreen()
            }
        }
        .onAppear {
            let key = "FirstTimeUser"
            let defaults = UserDefaults.standard
            if defaults.object(forKey: key) == nil {
                defaults.set(true, forKey: key)
                firstTimeUser = true
            }
        }
    }
}

#Preview("Onboarding") {
    ContentView()
}

