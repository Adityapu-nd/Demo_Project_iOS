//
//  BarChartView.swift
//  Expense_Tracker_Final
//
//  Created by Aditya Pundlik on 10/02/26.
//


import SwiftUI
import Charts
import SwiftData

struct BarChartView: View {
    let weeklyData: [WeeklySpending]
    var body: some View {
        VStack(spacing: 12) {
            // Bar chart for weekly spending
            Chart(weeklyData) { item in
                BarMark(
                    x: .value("Week", item.weekLabel),
                    y: .value("Amount", item.amount)
                )
                .foregroundStyle(Color(red: 0.22, green: 0.47, blue: 0.87))
            }
            .frame(height: 180)
        }
    }
}

struct WeeklySpending: Identifiable {
    let id = UUID()
    let weekLabel: String // e.g. "1-7", "8-14", etc.
    let amount: Double
}
