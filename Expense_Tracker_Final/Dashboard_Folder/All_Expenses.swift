//
//  All_Expenses.swift
//  Expense_Tracker_Final
//
//  Created by Aditya Pundlik on 10/02/26.
//
import SwiftUI
import SwiftData

struct All_Expenses: View {
    @Query(sort: \Expense.date, order: .reverse) private var expenses: [Expense]
    @State private var selectedExpense: Expense? = nil
    @State private var showModifySheet = false
    @Environment(\.dismiss) private var dismiss
    
    enum SortOption: String, CaseIterable, Identifiable {
        case dateDesc = "Date (Newest First)"
        case dateAsc = "Date (Oldest First)"
        case priceDesc = "Price (High to Low)"
        case priceAsc = "Price (Low to High)"
        var id: String { self.rawValue }
    }
    
    @State private var selectedSort: SortOption = .dateDesc
    
    private var sortedExpenses: [Expense] {
        switch selectedSort {
        case .dateDesc:
            return expenses.sorted { $0.date > $1.date }
        case .dateAsc:
            return expenses.sorted { $0.date < $1.date }
        case .priceDesc:
            return expenses.sorted { $0.amount > $1.amount }
        case .priceAsc:
            return expenses.sorted { $0.amount < $1.amount }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Button(action: { dismiss() }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(Color(red: 0.22, green: 0.47, blue: 0.87))
                                    .imageScale(.large)
                                    .padding(.trailing, 8)
                            }
                            Text("All Expenses")
                                .font(.largeTitle.bold())
                                .foregroundColor(Color(red: 0.22, green: 0.47, blue: 0.87))
                            Spacer()
                        }
                        .padding([.top, .horizontal])
                        // Sorting dropdown
                        HStack {
                            Text("Sort by:")
                                .foregroundColor(Color(red: 0.22, green: 0.47, blue: 0.87))
                                .font(.headline)
                            Picker("Sort by", selection: $selectedSort) {
                                ForEach(SortOption.allCases) { option in
                                    Text(option.rawValue).tag(option)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .accentColor(Color(red: 0.22, green: 0.47, blue: 0.87))
                            .frame(minWidth: 200, alignment: .leading) // Make the picker wider
                            .layoutPriority(1)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                        ForEach(sortedExpenses) { expense in
                            DashboardExpenseRow(
                                expense: expense,
                                onModify: {
                                    selectedExpense = expense
                                    showModifySheet = true
                                }
                            )
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        }
                        Spacer(minLength: 32)
                    }
                }
            }
            .sheet(item: $selectedExpense) { expense in
                Modify_Expense(expense: expense)
            }
        }
    }
}

#Preview() {
    All_Expenses()
}
