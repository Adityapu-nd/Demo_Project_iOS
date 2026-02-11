import SwiftUI

struct NewUserScreen: View {
    var onFinish: (() -> Void)? = nil
    @State private var goToIntro = false
    var body: some View {
        NavigationStack {
            ZStack {
                // Blue/white vertical gradient background
                LinearGradient(gradient: Gradient(colors: [Color.white, Color(red: 0.22, green: 0.47, blue: 0.87)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                // Subtle background image
                Image("wallet-full-of-money-cartoon-style-illustration-on-blue-background-vector")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 260, height: 260)
                    .opacity(0.18)
                    .offset(y: -60)
                    .ignoresSafeArea()

                VStack(alignment: .center, spacing: 28) {
                    VStack(alignment: .center, spacing: 8) {
                        Text("Welcome to")
                            .font(.largeTitle.bold())
                            .foregroundStyle(Color(red: 0.22, green: 0.47, blue: 0.87))
                            .multilineTextAlignment(.center)
                        Text("Expense Tracker")
                            .font(.largeTitle.bold())
                            .foregroundStyle(Color(red: 0.22, green: 0.47, blue: 0.87))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)

                    // Feature card
                    VStack(alignment: .leading, spacing: 16) {
                        FeatureRow(text: "Track Your Spending")
                        FeatureRow(text: "Categorize Expenses")
                        FeatureRow(text: "Gain Insights")
                    }
                    .padding(20)
                    .background(Color.white.opacity(0.95))
                    .cornerRadius(18)
                    .shadow(color: Color(red: 0.22, green: 0.47, blue: 0.87).opacity(0.08), radius: 10, x: 0, y: 4)

                    Spacer(minLength: 24)

                    NavigationLink(destination: new_user_screen_2(onFinish: onFinish), isActive: $goToIntro) {
                        Text("Get Started")
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
                    .padding(.top, 8)
                    .simultaneousGesture(TapGesture().onEnded { goToIntro = true })

                    HStack {
                        Spacer()
                        Button(action: {
                            onFinish?()
                        }) {
                            Text("Skip")
                                .font(.subheadline)
                                .foregroundStyle(Color(red: 0.22, green: 0.47, blue: 0.87))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 18)
                                .background(Color.white.opacity(0.7))
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .shadow(color: Color(red: 0.22, green: 0.47, blue: 0.87).opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                    }
                }
                .padding(28)
            }
        }
    }
}

private struct FeatureRow: View {
    let text: String

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color(red: 0.22, green: 0.47, blue: 0.87).opacity(0.13))
                    .frame(width: 36, height: 36)
                Image(systemName: "creditcard")
                    .font(.title3)
                    .foregroundColor(Color(red: 0.22, green: 0.47, blue: 0.87))
            }
            Text(text)
                .foregroundStyle(Color(red: 0.22, green: 0.47, blue: 0.87))
                .font(.body)
        }
    }
}

#Preview("Onboarding") {
    NewUserScreen()
}
