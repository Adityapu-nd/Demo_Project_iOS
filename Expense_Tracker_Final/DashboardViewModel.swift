//
//  DashboardViewModel.swift
//  Expense Tracker
//
//  Created by Aditya Pundlik on 09/02/26.
//

import Foundation
import Combine

struct CategoryTotal: Identifiable {
    let id = UUID()
    let category: String
    let total: Double
}

final class DashboardViewModel: ObservableObject {
    // Example published property to ensure ObservableObject conformance
    @Published var dummy: Bool = false

    private let inrFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "INR"
        return f
    }()

    func totalSpending(for expenses: [Expense]) -> Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

    func totalSpendingText(for expenses: [Expense]) -> String {
        let total = totalSpending(for: expenses)
        return inrFormatter.string(from: NSNumber(value: total)) ?? "₹0.00"
    }

    func spendingByCategory(for expenses: [Expense]) -> [CategoryTotal] {
        let grouped = Dictionary(grouping: expenses, by: { $0.category })
        let mapped = grouped.map { (key, values) in
            CategoryTotal(category: key, total: values.reduce(0) { $0 + $1.amount })
        }
        return mapped.sorted { $0.total > $1.total }
    }

    func amountText(_ amount: Double) -> String {
        inrFormatter.string(from: NSNumber(value: amount)) ?? "₹0.00"
    }
    
    func todaysSpending(for expenses: [Expense]) -> Double {
        let today = Calendar.current.startOfDay(for: Date())
        return expenses.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }.reduce(0) { $0 + $1.amount }
    }
    func todaysSpendingText(for expenses: [Expense]) -> String {
        let total = todaysSpending(for: expenses)
        return inrFormatter.string(from: NSNumber(value: total)) ?? "₹0.00"
    }
    func thisMonthSpending(for expenses: [Expense]) -> Double {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        return expenses.filter { $0.date >= startOfMonth && $0.date <= now }.reduce(0) { $0 + $1.amount }
    }
    func thisMonthSpendingText(for expenses: [Expense]) -> String {
        let total = thisMonthSpending(for: expenses)
        return inrFormatter.string(from: NSNumber(value: total)) ?? "₹0.00"
    }
}
