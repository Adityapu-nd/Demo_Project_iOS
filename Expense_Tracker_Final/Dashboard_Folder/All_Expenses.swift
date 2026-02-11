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
                        ForEach(expenses) { expense in
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
