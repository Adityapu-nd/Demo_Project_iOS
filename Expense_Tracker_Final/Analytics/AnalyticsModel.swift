//
//  AnalyticsModel.swift
//  Expense_Tracker_Final
//
//  Created by Aditya Pundlik on 18/02/26.
//
import SwiftUI
import Charts
import SwiftData
// Function to generate analytics data from real expenses

// Blue theme color palette
let mainBlue = Color(red: 0.22, green: 0.47, blue: 0.87)
let lightBlue = Color(red: 0.36, green: 0.65, blue: 0.98)
let midBlue = Color(red: 0.28, green: 0.56, blue: 0.93)
let fadedBlue = Color(red: 0.22, green: 0.47, blue: 0.87).opacity(0.3)

// Category to color mapping (add more as needed)
let categoryColorMap: [String: Color] = [
    "Food": mainBlue,
    "Shopping": lightBlue,
    "Transport": midBlue,
    "Entertainment": fadedBlue,
    "Other": Color.gray.opacity(0.3)
]


