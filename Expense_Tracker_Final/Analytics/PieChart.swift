//
//  PieChart.swift
//  Expense_Tracker_Final
//
//  Created by Aditya Pundlik on 10/02/26.
//
import SwiftUI
import Foundation
import Charts
struct DonutChartView: View {
    let categoryData: [CategoryData]
    var body: some View {
        Chart(categoryData) { item in
            SectorMark(
                angle: .value("Amount", item.amount),
                innerRadius: .ratio(0.6)
            )
            .foregroundStyle(item.color)
        }
        .frame(width: 160, height: 160)
    }
}

struct CategoryData: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let color: Color
}
