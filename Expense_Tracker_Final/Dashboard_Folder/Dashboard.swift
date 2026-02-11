//
//  Dashboard.swift
//  Expense Tracker
//
//  Created by Aditya Pundlik on 28/01/26.
//
import Foundation
import SwiftUI
import SwiftData



struct Dashboard: View {
    @AppStorage("FirstTimeUser") private var firstTimeUser: Bool = false

    @Query(sort: \Expense.date, order: .reverse) private var expenses: [Expense]
    @StateObject private var viewModel = DashboardViewModel()
    @State private var showAddExpense = false
    @State private var showAnalytics = false
    @State private var showAllExpenses = false
    @State private var showOnboarding = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea() // Set background to white
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        HStack {
                            Text("Dashboard")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(Color(red: 0.22, green: 0.47, blue: 0.87))
                            Spacer()
                            Button(action: {}) {
                                Image(systemName: "ellipsis.circle")
                                    .font(.title2)
                                    .foregroundColor(Color(red: 0.22, green: 0.47, blue: 0.87).opacity(0.85))
                            }
                        }
                        .padding([.top, .horizontal])
                        .padding(.bottom, 8)

                        // User row (removed John menu, just greeting)
                        HStack {
                            Text("Hello.")
                                .font(.title3)
                                .foregroundColor(Color(red: 0.22, green: 0.47, blue: 0.87).opacity(0.9))
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 12)

                        // Spending summary cards
                        HStack(spacing: 16) {
                            DashboardSummaryCard(title: "Today's Spending", value: viewModel.todaysSpendingText(for: expenses))
                            DashboardSummaryCard(title: "This Month", value: viewModel.thisMonthSpendingText(for: expenses))
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 18)

                        // Analytics button (replaces Add Expense)
                        Button(action: {
                            showAnalytics = true
                        }) {
                            HStack {
                                Image(systemName: "chart.bar.xaxis")
                                    .font(.title2)
                                Text("Analytics")
                                    .fontWeight(.semibold)
                            }
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color(red: 0.22, green: 0.47, blue: 0.87), Color(red: 0.36, green: 0.65, blue: 0.98)]), startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(14)
                            .shadow(color: Color(red: 0.22, green: 0.47, blue: 0.87).opacity(0.18), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 18)
                        .sheet(isPresented: $showAnalytics) {
                            Analytics()
                        }

                        // Recent Expenses
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Recent Expenses")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.22, green: 0.47, blue: 0.87))
                                .padding(.horizontal)
                                .padding(.top, 8)
                            ForEach(expenses.prefix(3)) { expense in
                                DashboardExpenseRow(expense: expense)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(18)
                        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                        .padding(.horizontal)
                        .padding(.bottom, 16)

                        // All Expenses button below recent expenses
                        Button(action: {
                            showAllExpenses = true
                        }) {
                            HStack {
                                Image(systemName: "tray.full")
                                    .font(.title2)
                                Text("All Expenses")
                                    .fontWeight(.semibold)
                            }
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color(red: 0.22, green: 0.47, blue: 0.87), Color(red: 0.36, green: 0.65, blue: 0.98)]), startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(14)
                            .shadow(color: Color(red: 0.22, green: 0.47, blue: 0.87).opacity(0.18), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 18)
                        .sheet(isPresented: $showAllExpenses) {
                            All_Expenses()
                        }

                        // Monthly Spending Calendar View
                        MonthlySpendingCalendarView(expenses: expenses)
                            .padding(.horizontal)
                            .padding(.bottom, 18)

                        Spacer()
                    }
                }
                // Floating + button (bottom right)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showAddExpense = true }) {
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding(18)
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [Color(red: 0.22, green: 0.47, blue: 0.87), Color(red: 0.36, green: 0.65, blue: 0.98)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .clipShape(Circle())
                                .shadow(color: Color(red: 0.22, green: 0.47, blue: 0.87).opacity(0.18), radius: 8, x: 0, y: 4)
                        }
                        .padding(.trailing, 28)
                        .padding(.bottom, 32)
                    }
                }
            }
            .sheet(isPresented: $showAddExpense) {
                Add_Expense_Screen()
            }
            .onAppear {
                if firstTimeUser {
                    showOnboarding = true
                }
            }
            .fullScreenCover(isPresented: $showOnboarding, onDismiss: {
                firstTimeUser = false
            }) {
                NewUserScreen(onFinish: {
                    showOnboarding = false
                    firstTimeUser = false
                })
            }
        }
    }
}

struct DashboardSummaryCard: View {
    let title: String
    let value: String
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.7))
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(red: 0.22, green: 0.47, blue: 0.87))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 2)
    }
}

struct DashboardExpenseRow: View {
    let expense: Expense
    var onModify: (() -> Void)? = nil
    @State private var expanded = false
    
    // Helper to map categories to SF Symbols
    func iconName(for category: String) -> String {
        switch category.lowercased() {
        case "food": return "fork.knife"
        case "transport": return "car.fill"
        case "shopping": return "bag.fill"
        case "bills": return "doc.text.fill"
        case "entertainment": return "gamecontroller.fill"
        case "other": return "ellipsis.circle.fill"
        default: return "creditcard.fill"
        }
    }
    
    // Helper to map categories to color
    func iconColor(for category: String) -> Color {
        switch category.lowercased() {
        case "food": return Color(red: 0.22, green: 0.47, blue: 0.87)
        case "transport": return Color(red: 0.36, green: 0.65, blue: 0.98)
        case "shopping": return Color.orange
        case "bills": return Color.purple
        case "entertainment": return Color.green
        case "other": return Color.gray
        default: return Color.blue
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: { withAnimation { expanded.toggle() } }) {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(iconColor(for: expense.category).opacity(0.18))
                            .frame(width: 38, height: 38)
                        Image(systemName: iconName(for: expense.category))
                            .resizable()
                            .frame(width: 22, height: 22)
                            .foregroundColor(iconColor(for: expense.category))
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(expense.note.isEmpty ? expense.category : expense.note)
                            .font(.body)
                            .foregroundColor(.black)
                        Text(expense.category)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("₹\(expense.amount, specifier: "%.2f")")
                            .font(.headline)
                            .foregroundColor(.black)
                        Text(expense.date, style: .date)
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            if expanded {
                VStack(alignment: .leading, spacing: 6) {
                    Divider()
                    HStack {
                        Text("Date & Time:")
                            .font(.caption.bold())
                            .foregroundColor(.gray)
                        Spacer()
                        Text(expense.date, style: .date)
                        Text(expense.date, style: .time)
                    }
                    HStack {
                        Text("Category:")
                            .font(.caption.bold())
                            .foregroundColor(.gray)
                        Spacer()
                        Text(expense.category)
                    }
                    HStack {
                        Text("Note:")
                            .font(.caption.bold())
                            .foregroundColor(.gray)
                        Spacer()
                        Text(expense.note.isEmpty ? "-" : expense.note)
                    }
                    HStack {
                        Text("Amount:")
                            .font(.caption.bold())
                            .foregroundColor(.gray)
                        Spacer()
                        Text("₹\(expense.amount, specifier: "%.2f")")
                    }
                    HStack {
                        Spacer()
                        if let onModify = onModify {
                            Button(action: { onModify() }) {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text("Modify")
                                }
                                .font(.subheadline.bold())
                                .foregroundColor(.white)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 18)
                                .background(Color(red: 0.22, green: 0.47, blue: 0.87))
                                .cornerRadius(8)
                            }
                        }
                        Spacer()
                    }
                }
                .padding(.top, 6)
                .padding(.bottom, 8)
                .padding(.horizontal, 4)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
    }
}

#Preview {
    Dashboard()
}
