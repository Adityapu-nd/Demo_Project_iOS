//
//  Modify_Expense.swift
//  Expense Tracker
//
//  Created by Aditya Pundlik on 28/01/26.
//

import SwiftUI
import SwiftData

struct Modify_Expense: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    var expense: Expense
    @State private var amountText: String
    @State private var selectedCategory: String
    @State private var date: Date
    @State private var paymentMethod: String

    init(expense: Expense) {
        self.expense = expense
        _amountText = State(initialValue: String(format: "%.2f", expense.amount))
        _selectedCategory = State(initialValue: expense.category)
        _date = State(initialValue: expense.date)
        _paymentMethod = State(initialValue: {
            switch expense.paymentMethod {
            case .cash: return "Cash"
            case .card: return "Card"
            case .upi: return "UPI"
            case .bankTransfer: return "BankTransfer"
            default: return "Other"
            }
        }())
    }

    // Validation computed property
    var isAmountValid: Bool {
        guard let value = Double(amountText), value != 0 else { return false }
        let parts = amountText.split(separator: ".")
        if let intPart = parts.first, intPart.count > 10 { return false }
        if parts.count == 2, parts[1].count > 2 { return false }
        if value < 0 { return false }
        return true
    }
    func roundedAmountText(_ text: String) -> String {
        if let value = Double(text) {
            return String(format: "%.2f", value)
        }
        return text
    }

    var body: some View {
        ZStack {
            // Soft blue background
            Color(red: 240/255, green: 246/255, blue: 252/255)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                // Top bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundStyle(.indigo)
                            .padding(8)
                    }
                    Spacer()
                    Text("Edit Expense")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Spacer()
                    Color.clear.frame(width: 32, height: 32)
                }
                .padding(.horizontal)

                // Card
                VStack(spacing: 0) {
                    // Amount row
                    HStack(spacing: 4) {
                        Text("₹")
                            .foregroundStyle(.secondary)
                        TextField("0.00", text: $amountText)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(.primary)
                            .frame(minWidth: 80)
                    }
                    .padding()
                    .background(Color.white)

                    Divider()

                    // Category row
                    HStack {
                        Text("Category")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Picker("Category", selection: $selectedCategory) {
                            Text("Food").tag("Food")
                            Text("Transport").tag("Transport")
                            Text("Shopping").tag("Shopping")
                            Text("Bills").tag("Bills")
                            Text("Other").tag("Other")
                        }
                        .pickerStyle(.menu)
                    }
                    .padding()
                    .background(Color.white)

                    Divider()

                    // Date row
                    HStack {
                        Text("Date")
                            .foregroundStyle(.secondary)
                        Spacer()
                        DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                            .labelsHidden()
                            .datePickerStyle(.compact)
                    }
                    .padding()
                    .background(Color.white)

                    Divider()

                    // Payment Method row
                    HStack {
                        Text("Payment Method")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Picker("Payment Method", selection: $paymentMethod) {
                            Text("Cash").tag("Cash")
                            Text("Card").tag("Card")
                            Text("UPI").tag("UPI")
                            Text("Other").tag("Other")
                        }
                        .pickerStyle(.menu)
                    }
                    .padding()
                    .background(Color.white)

                    Divider()
                }
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.white)
                )
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 8)
                .padding(.horizontal)

                // Bottom buttons
                HStack(spacing: 12) {
                    Button(role: .destructive, action: {
                        do {
                            try ExpenseStore.deleteExpense(modelContext: modelContext, expense: expense)
                            dismiss()
                        } catch {
                            print("Failed to delete expense: \(error)")
                        }
                    }) {
                        Text("Delete")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.red.opacity(0.1))
                            .foregroundStyle(.red)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.red.opacity(0.3), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                    }

                    Button(action: {
                        amountText = roundedAmountText(amountText)
                        do {
                            try ExpenseStore.updateExpense(
                                modelContext: modelContext,
                                expense: expense,
                                amountText: amountText,
                                category: selectedCategory,
                                date: date,
                                paymentMethodString: paymentMethod,
                                note: expense.note // or add a note field if needed
                            )
                            dismiss()
                        } catch {
                            print("Failed to update expense: \(error)")
                        }
                    }) {
                        Text("Save")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                    }
                    .background(
                        LinearGradient(colors: [Color.blue, Color.indigo], startPoint: .leading, endPoint: .trailing)
                            .opacity(isAmountValid ? 1 : 0)
                    )
                    .background(
                        Color.gray.opacity(0.3).opacity(isAmountValid ? 0 : 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .disabled(!isAmountValid)
                }
                .padding(.horizontal)
                Spacer()
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    let previewExpense = Expense(date: .now, note: "Lunch", amount: 30.0, paymentMethod: .cash, category: "Food")
    return Modify_Expense(expense: previewExpense)
}
