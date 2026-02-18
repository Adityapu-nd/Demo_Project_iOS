//
//  MonthlySpendingCalendarView.swift
//  Expense_Tracker_Final
//
//  Created by Aditya Pundlik on 10/02/26.
//


import SwiftUI

struct MonthlySpendingCalendarView: View {
    // MARK: - Data
    let expenses: [Expense]
    @State private var displayedMonth: Date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))!
    let calendar = Calendar.current
    let days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    var monthTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: displayedMonth)
    }
    var dailyAmounts: [Int?] {
        let range = calendar.range(of: .day, in: .month, for: displayedMonth) ?? 1..<29
        let daysArray = Array(range)
        var amounts = Array(repeating: 0, count: daysArray.count)
        for expense in expenses {
            if calendar.isDate(expense.date, equalTo: displayedMonth, toGranularity: .month) && calendar.isDate(expense.date, equalTo: displayedMonth, toGranularity: .year) {
                let day = calendar.component(.day, from: expense.date)
                if day >= 1 && day <= amounts.count {
                    // Only add the expense amount for the specific day
                    amounts[day - 1] += Int(expense.amount)
                }
            }
        }
        return amounts
    }
    let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 7)

    // MARK: - View
    var body: some View {
        VStack(spacing: 20) {

            // Month Header
            HStack {
                Button(action: {
                    if let prevMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth) {
                        displayedMonth = prevMonth
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(red: 0.22, green: 0.47, blue: 0.87))
                }

                Spacer()

                Text(monthTitle)
                    .foregroundColor(Color(red: 0.22, green: 0.47, blue: 0.87))
                    .font(.headline)

                Spacer()

                Button(action: {
                    if let nextMonth = calendar.date(byAdding: .month, value: 1, to: displayedMonth) {
                        displayedMonth = nextMonth
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(red: 0.22, green: 0.47, blue: 0.87))
                }
            }
            .padding(.horizontal)

            // Weekdays
            LazyVGrid(columns: columns) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)

            // Calendar Grid
            let range = calendar.range(of: .day, in: .month, for: displayedMonth) ?? 1..<29
            let daysArray = Array(range)
            let firstOfMonth = displayedMonth
            let weekdayOffset = calendar.component(.weekday, from: firstOfMonth) - calendar.firstWeekday
            let totalCells = daysArray.count + max(weekdayOffset, 0)
            let rows = Int(ceil(Double(totalCells) / 7.0))
            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(0..<(rows * 7), id: \.self) { index in
                    if index < max(weekdayOffset, 0) || index - max(weekdayOffset, 0) >= daysArray.count {
                        Color.clear.frame(height: 60)
                    } else {
                        let day = index - max(weekdayOffset, 0) + 1
                        let isToday = calendar.isDateInToday(calendar.date(bySetting: .day, value: day, of: displayedMonth) ?? Date())
                        DayCell(
                            day: day,
                            amount: dailyAmounts[day - 1],
                            isToday: isToday
                        )
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color(red: 0.22, green: 0.47, blue: 0.87).opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Day Cell
struct DayCell: View {
    let day: Int
    let amount: Int?
    let isToday: Bool

    var body: some View {
        VStack(spacing: 6) {
            Text("\(day)")
                .foregroundColor(isToday ? .white : Color(red: 0.22, green: 0.47, blue: 0.87))
                .font(.subheadline)
                .bold()

            if let amount = amount, amount > 0 {
                Text("₹\(amount)")
                    .font(.caption)
                    .foregroundColor(isToday ? .white : Color(red: 0.22, green: 0.47, blue: 0.87).opacity(0.9))
            } else {
                Text("0")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isToday ? Color(red: 0.22, green: 0.47, blue: 0.87) : Color.blue.opacity(amount ?? 0 > 0 ? 0.08 : 0.02))
        )
    }
}

// MARK: - Preview
#Preview {
    MonthlySpendingCalendarView(expenses: [])
}
