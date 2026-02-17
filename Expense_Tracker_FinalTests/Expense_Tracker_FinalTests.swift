//
//  Expense_Tracker_FinalTests.swift
//  Expense_Tracker_FinalTests
//
//  Created by Aditya Pundlik on 17/02/26.
//

import XCTest
@testable import Expense_Tracker_Final

final class Expense_Tracker_FinalTests: XCTestCase {
    func testTotalSpending() {
        let viewModel = DashboardViewModel()
        let expenses = [
            Expense(date: Date(), note: "", amount: 100, paymentMethod: .cash, category: "Food"),
            Expense(date: Date(), note: "", amount: 200, paymentMethod: .cash, category: "Transport")
        ]
        let total = viewModel.totalSpending(for: expenses)
        XCTAssertEqual(total, 300)
    }

    func testSpendingByCategory() {
        let viewModel = DashboardViewModel()
        let expenses = [
            Expense(date: Date(), note: "", amount: 100, paymentMethod: .cash, category: "Food"),
            Expense(date: Date(), note: "", amount: 200, paymentMethod: .cash, category: "Transport")
        ]
        let result = viewModel.spendingByCategory(for: expenses)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.first?.total, 200) // Transport comes first if sorted by total desc
    }
}
