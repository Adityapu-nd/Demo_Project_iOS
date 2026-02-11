//
//  new_user_screen_2.swift
//  Expense Tracker
//
//  Created by Aditya Pundlik on 28/01/26.
//

import SwiftUI

struct new_user_screen_2: View {
    var onFinish: (() -> Void)? = nil
    @State private var goToDashboard = false
    var body: some View {
        ZStack {
            // Blue/white vertical gradient background
            LinearGradient(gradient: Gradient(colors: [Color.white, Color(red: 0.22, green: 0.47, blue: 0.87)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing: 32) {
                Spacer(minLength: 24)
                VStack(spacing: 12) {
                    Text("How Expense Tracker Works")
                        .font(.title.bold())
                        .foregroundStyle(Color(red: 0.22, green: 0.47, blue: 0.87))
                        .multilineTextAlignment(.center)
                    Text("Easily add your daily expenses, categorize them, and get instant insights with beautiful charts and summaries. Stay on top of your spending and reach your financial goals!")
                        .font(.body)
                        .foregroundStyle(Color(red: 0.22, green: 0.47, blue: 0.87).opacity(0.85))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }
                .padding(.top, 24)
                .padding(.bottom, 8)
                .frame(maxWidth: .infinity)

                VStack(alignment: .leading, spacing: 18) {
                    FeatureRow2(icon: "plus.circle.fill", text: "Add expenses quickly with a tap.")
                    FeatureRow2(icon: "tag.fill", text: "Categorize for better tracking.")
                    FeatureRow2(icon: "chart.pie.fill", text: "Visualize your spending with analytics.")
                    FeatureRow2(icon: "calendar", text: "See your monthly and daily patterns.")
                    FeatureRow2(icon: "pencil", text: "Edit or delete expenses anytime.")
                }
                .padding(20)
                .background(Color.white.opacity(0.95))
                .cornerRadius(18)
                .shadow(color: Color(red: 0.22, green: 0.47, blue: 0.87).opacity(0.08), radius: 10, x: 0, y: 4)
                .padding(.horizontal, 8)

                Spacer()

                Button(action: {
                    goToDashboard = true
                    onFinish?()
                }) {
                    Text("Continue to Dashboard")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color(red: 0.22, green: 0.47, blue: 0.87), Color(red: 0.36, green: 0.65, blue: 0.98)]), startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: Color(red: 0.22, green: 0.47, blue: 0.87).opacity(0.15), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 24)
                NavigationLink(destination: Dashboard(), isActive: $goToDashboard) { EmptyView() }
            }
            .padding(.horizontal, 18)
        }
    }
}

private struct FeatureRow2: View {
    let icon: String
    let text: String
    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color(red: 0.22, green: 0.47, blue: 0.87).opacity(0.13))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(Color(red: 0.22, green: 0.47, blue: 0.87))
            }
            Text(text)
                .foregroundStyle(Color(red: 0.22, green: 0.47, blue: 0.87))
                .font(.body)
        }
    }
}

#Preview {
    new_user_screen_2()
}
