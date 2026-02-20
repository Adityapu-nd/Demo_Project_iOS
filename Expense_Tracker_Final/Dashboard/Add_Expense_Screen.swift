//  Add_Expensemat strin_Screen.swift
//  Expense Tracker
//
//  Created by Aditya Pundlik on 28/01/26.
//

import SwiftUI
import SwiftData

struct Add_Expense_Screen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var amountText: String = ""
    @State private var selectedCategory: String? = nil
    @State private var date: Date = .now
    @State private var paymentMethod: String = "Cash"
    @State private var currency: String = "INR"
    @State private var note: String = ""

    private let currencyConverter = CurrencyConverter.shared

    // Validation computed property
    var isAmountValid: Bool {
        // Check if amountText is a valid Double
        guard let value = Double(amountText), value != 0 else { return false }
        // Check for max 10 digits before decimal
        let parts = amountText.split(separator: ".")
        if let intPart = parts.first, intPart.count > 10 { return false }
        // Check for max 2 decimals
        if parts.count == 2, parts[1].count > 2 { return false }
        // Check for non-negative
        if value < 0 { return false }
        return true
    }
    // Helper to round to 2 decimals
    func roundedAmountText(_ text: String) -> String {
        if let value = Double(text) {
            return String(format: "%.2f", Double(value))
        }
        return text
    }

    var body: some View {
        ZStack {
            // Soft blue background like the screenshot
            Color(red: 240/255, green: 246/255, blue: 252/255)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                // Top navigation row (back + title)
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundStyle(.indigo)
                            .padding(8)
                    }
                    Spacer()
                    Text("Add Expense")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Spacer()
                    // Placeholder to balance the back button width
                    Color.clear.frame(width: 32, height: 32)
                }
                .padding(.horizontal)

                // Card
                VStack(spacing: 0) {
                    // Amount row
                    HStack {
                        Text("Amount")
                            .foregroundStyle(.secondary)
                        Spacer()
                        TextField("₹0.00", text: $amountText)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(.primary)
                    }
                    .padding()
                    .background(Color.white)

                    Divider()

                    // Category row
                    HStack {
                        Text("Category")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Picker(selection: Binding(
                            get: { selectedCategory ?? "Food" },
                            set: { selectedCategory = $0.isEmpty ? nil : $0 }
                        ), label: Text(selectedCategory ?? "Select Category").foregroundStyle(selectedCategory == nil ? .blue : .primary)) {
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

                    // Date & Time row
                    HStack {
                        Text("Date & Time")
                            .foregroundStyle(.secondary)
                        Spacer()
                        DatePicker(
                            "Date & Time",
                            selection: $date,
                            displayedComponents: [.date, .hourAndMinute]
                        )
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
                    
                    HStack {
                        Text("Currency")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Picker("Currency", selection: $currency) {
                            Text("INR").tag("INR")
                            Text("USD").tag("USD")
                            Text("EUR").tag("EUR")
                            Text("GBP").tag("GBP")
                        }
                        .pickerStyle(.menu)
                    }
                    .padding()
                    .background(Color.white)

                    Divider()

                    // Note row
                    HStack {
                        Text("Note")
                            .foregroundStyle(.secondary)
                        Spacer()
                        TextField("Optional", text: $note)
                            .keyboardType(.default)
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color.white)
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
                    Button(action: { dismiss() }) {
                        Text("Cancel")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .foregroundStyle(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                    }

                    Button(action: {
                        amountText = roundedAmountText(amountText)
                        var amountToSave = Double(amountText) ?? 0.0
                        if currency != "INR" {
                            amountToSave = currencyConverter.convertToINR(amount: amountToSave, from: currency)
                        }
                        do {
                            try ExpenseStore.addExpense(
                                modelContext: modelContext,
                                amountText: String(format: "%.2f", amountToSave),
                                category: selectedCategory,
                                date: date,
                                paymentMethodString: paymentMethod,
                                note: note
                            )
                            amountText = ""
                            selectedCategory = "Food"
                            date = .now
                            paymentMethod = "Cash"
                            note = ""
                            dismiss()
                        } catch {
                            print("Failed to save expense: \(error)")
                        }
                    }) {
                        Text("Save")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 1,style: .continuous))
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                    }
                    .background(
                        isAmountValid ? AnyView(LinearGradient(colors: [Color.blue, Color.indigo], startPoint: .leading, endPoint: .trailing)) : AnyView(Color.gray.opacity(0.3))
                    )
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
    Add_Expense_Screen()
}
