//
//  Structures.swift
//  Expense Tracker
//
//  Created by Aditya Pundlik on 09/02/26.
//
import Foundation
import SwiftData
import SwiftUI
// MARK: - Models

// MARK: - Supporting Types

enum PaymentMethod: String, Codable, CaseIterable, Identifiable {
    case cash
    case card
    case upi
    case bankTransfer
    case other

    var id: String { rawValue }
}

@Model final class Expense: Identifiable {
    // Unique identifier for use in lists and persistence
    @Attribute(.unique) var id: UUID
    // When the expense occurred
    var date: Date

    // Description or note about the expense
    var note: String

    // Monetary amount of the expense
    var amount: Double

    // How this expense was paid
    var paymentMethod: PaymentMethod

    // Category of the expense (user-defined)
    var category: String

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        note: String,
        amount: Double,
        paymentMethod: PaymentMethod = .other,
        category: String = "Other"
    ) {
        self.id = id
        self.date = date
        self.note = note
        self.amount = amount
        self.paymentMethod = paymentMethod
        self.category = category
    }
}


struct CategorySpending: Identifiable {
    let id = UUID()
    let category: String
    let amount: Double
    let color: Color
}


struct DailySpending: Identifiable {
    let id = UUID()
    let day: String
    let amount: Double
}


@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
