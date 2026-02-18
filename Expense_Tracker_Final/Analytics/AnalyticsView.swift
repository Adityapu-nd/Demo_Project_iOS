import SwiftUI
import Charts
import SwiftData

struct Analytics: View {
    @Query(sort: \Expense.date, order: .reverse) private var expenses: [Expense]
    @State private var selectedMonth: Date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date())) ?? Date()
    var categoryData: [CategorySpending] { categorySpendingData(from: expensesForSelectedMonth) }
    var weeklyData: [WeeklySpending] { weeklySpendingData(from: expensesForSelectedMonth) }
    var monthTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedMonth)
    }
    var expensesForSelectedMonth: [Expense] {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedMonth))!
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        let endOfMonth = calendar.date(byAdding: .day, value: range.count - 1, to: startOfMonth)!
        return expenses.filter { $0.date >= startOfMonth && $0.date <= endOfMonth }
    }
    func goToPrevMonth() {
        if let prev = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) {
            selectedMonth = prev
        }
    }
    func goToNextMonth() {
        if let next = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) {
            selectedMonth = next
        }
    }
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 6) {
                    HStack {
                        Button(action: {
                            // Dismiss the sheet or pop the view
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let root = windowScene.windows.first?.rootViewController {
                                root.dismiss(animated: true)
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(Color(red: 0.22, green: 0.47, blue: 0.87))
                        }
                        Spacer()
                    }
                    Text("Analytics")
                        .font(.title2)
                        .bold()
                    // Month navigation with arrows (replaces This Month dropdown)
                    HStack(spacing: 12) {
                        Button(action: goToPrevMonth) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(Color(red: 0.22, green: 0.47, blue: 0.87))
                        }
                        Text(monthTitle)
                            .font(.headline)
                            .foregroundColor(Color(red: 0.22, green: 0.47, blue: 0.87))
                        Button(action: goToNextMonth) {
                            Image(systemName: "chevron.right")
                                .font(.title2)
                                .foregroundColor(Color(red: 0.22, green: 0.47, blue: 0.87))
                        }
                    }
                }

                // Spending by Category
                VStack(alignment: .leading, spacing: 16) {
                    Text("Spending by Category")
                        .font(.headline)

                    // Calculate total for percentage calculation
                    let total = categoryData.reduce(0) { $0 + $1.amount }

                    HStack(spacing: 24) {
                        DonutChartView(categoryData: categoryData.map { CategoryData(name: $0.category, amount: $0.amount, color: $0.color) })

                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(categoryData) { item in
                                HStack {
                                    Circle()
                                        .fill(item.color)
                                        .frame(width: 10, height: 10)

                                    Text(item.category)
                                        .font(.subheadline)

                                    Spacer()

                                    Text(total > 0 ? "\(Int((item.amount / total) * 100))%" : "0%")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }

                // Weekly Spending
                VStack(alignment: .leading, spacing: 16) {
                    Text("Weekly Spending")
                        .font(.headline)

                    BarChartView(
                        weeklyData: weeklyData
                    )
                    .frame(height: 220)
                }

                // Summary Section
                VStack(spacing: 12) {
                    SummaryRow(title: "Top Category: \(categoryData.first?.category ?? "-")", value: "₹\(String(format: "%.2f", categoryData.first?.amount ?? 0))")
                    SummaryRow(title: "Average Daily Spend", value: averageDailySpendText)
                    SummaryRow(title: "Total This Month", value: totalThisMonthText)
                }
            }
            .padding()
        }
    }
}





#Preview {
    Analytics()
}

// Add computed properties for summary values
extension Analytics {
    var totalThisMonth: Double {
        expensesForSelectedMonth.reduce(0) { $0 + $1.amount }
    }
    var totalThisMonthText: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "INR"
        return formatter.string(from: NSNumber(value: totalThisMonth)) ?? "₹0.00"
    }
    var averageDailySpend: Double {
        let calendar = Calendar.current
        let days = Set(expensesForSelectedMonth.map { calendar.startOfDay(for: $0.date) }).count
        return days > 0 ? totalThisMonth / Double(days) : 0
    }
    var averageDailySpendText: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "INR"
        return formatter.string(from: NSNumber(value: averageDailySpend)) ?? "₹0.00"
    }
}
