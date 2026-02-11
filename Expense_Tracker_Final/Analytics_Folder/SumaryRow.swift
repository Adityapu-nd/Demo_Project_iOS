//
//  SumaryRow.swift
//  Expense_Tracker_Final
//
//  Created by Aditya Pundlik on 10/02/26.
//

import SwiftUI

struct SummaryRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .bold()
                .foregroundColor(.blue)
        }
    }
}
