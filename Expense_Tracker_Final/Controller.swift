//
//  Functions.swift
//  Expense Tracker
//
//  Created by Aditya Pundlik on 09/02/26.
//

import Foundation
import SwiftData

enum ExpenseStoreError: Error {
    case invalidAmount
}
struct ExpenseStore {
    static func addExpense(
        modelContext: ModelContext,
        amountText: String,
        category: String?,
        date: Date,
        paymentMethodString: String,
        note: String
    ) throws {
        let normalized = amountText.replacingOccurrences(of: ",", with: "")
        guard let amount = Double(normalized) else { throw ExpenseStoreError.invalidAmount }

        let pm: PaymentMethod
        switch paymentMethodString.lowercased() {
        case "cash": pm = .cash
        case "card": pm = .card
        case "upi": pm = .upi
        case "banktransfer": pm = .bankTransfer
        default: pm = .other
        }

        let expense = Expense(
            date: date,
            note: note,
            amount: amount,
            paymentMethod: pm,
            category: category ?? "Other"
        )
        modelContext.insert(expense)
        try modelContext.save()
    }

    static func updateExpense(
        modelContext: ModelContext,
        expense: Expense,
        amountText: String,
        category: String,
        date: Date,
        paymentMethodString: String,
        note: String
    ) throws {
        let normalized = amountText.replacingOccurrences(of: ",", with: "")
        guard let amount = Double(normalized) else { throw ExpenseStoreError.invalidAmount }

        let pm: PaymentMethod
        switch paymentMethodString.lowercased() {
        case "cash": pm = .cash
        case "card": pm = .card
        case "upi": pm = .upi
        case "banktransfer": pm = .bankTransfer
        default: pm = .other
        }

        expense.amount = amount
        expense.category = category
        expense.date = date
        expense.paymentMethod = pm
        expense.note = note

        try modelContext.save()
    }

    static func deleteExpense(modelContext: ModelContext, expense: Expense) throws {
        modelContext.delete(expense)
        try modelContext.save()
    }
}

