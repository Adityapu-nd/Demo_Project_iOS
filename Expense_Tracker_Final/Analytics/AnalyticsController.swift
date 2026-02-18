//
//  AnalyticsData.swift
//  Expense_Tracker_Final
//
//  Created by Aditya Pundlik on 10/02/26.
//


import SwiftUI
import Foundation
import SwiftData


// Optionally, a function for daily spending analytics
func categorySpendingData(from expenses: [Expense]) -> [CategorySpending] {
    let grouped = Dictionary(grouping: expenses, by: { $0.category })
    return grouped.map { (category, items) in
        CategorySpending(
            category: category,
            amount: items.reduce(0) { $0 + $1.amount },
            color: categoryColorMap[category] ?? fadedBlue
        )
    }.sorted { $0.amount > $1.amount }
}

func dailySpendingData(from expenses: [Expense]) -> [DailySpending] {
    let calendar = Calendar.current
    let grouped = Dictionary(grouping: expenses) { calendar.startOfDay(for: $0.date) }
    return grouped.map { (date, items) in
        DailySpending(
            day: DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none),
            amount: items.reduce(0) { $0 + $1.amount }
        )
    }.sorted { $0.day < $1.day }
}

// Returns weekly spending for a given month of expenses
func weeklySpendingData(from expenses: [Expense]) -> [WeeklySpending] {
    guard let first = expenses.first else { return [] }
    let calendar = Calendar.current
    let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: first.date))!
    let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
    let daysInMonth = range.count
    var weekRanges: [(Int, Int)] = []
    var start = 1
    while start <= daysInMonth {
        let end = min(start + 6, daysInMonth)
        weekRanges.append((start, end))
        start = end + 1
    }
    var result: [WeeklySpending] = []
    for (i, (startDay, endDay)) in weekRanges.enumerated() {
        let weekLabel = "\(startDay)-\(endDay)"
        let weekExpenses = expenses.filter {
            let day = calendar.component(.day, from: $0.date)
            return day >= startDay && day <= endDay
        }
        let total = weekExpenses.reduce(0) { $0 + $1.amount }
        result.append(WeeklySpending(weekLabel: weekLabel, amount: total))
    }
    return result
}
