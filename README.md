 # Expense Tracker Final

A modern iOS app for tracking daily expenses, visualizing spending patterns, and gaining financial insights. Built with SwiftUI and SwiftData.

## Features
- Add, edit, and delete expenses
- Categorize expenses (Food, Transport, Shopping, Bills, Other)
- View daily, monthly, and category-wise spending summaries
- Interactive dashboard with summary cards and analytics
- Monthly spending calendar view
- All expenses list with sorting
- Onboarding flow for new users
- Seamless navigation and theme matching

## Technologies Used
- SwiftUI for UI
- SwiftData for local persistence
- XCTest for unit testing

## Getting Started
1. Clone the repository:
   ```bash
   git clone <repo-url>
   ```
2. Open `Expense_Tracker_Final.xcodeproj` in Xcode.
3. Build and run on simulator or device.

## Project Structure
- `Expense_Tracker_Final/` - Main app source
  - `Dashboard_Folder/` - Dashboard, Add/Modify Expense, All Expenses, Calendar
  - `Analytics_Folder/` - Analytics, Pie/Bar/Line Charts
  - `First_Use/` - Onboarding screens
  - `Structures.swift` - Models (Expense, CategorySpending, etc.)
  - `Functions.swift` - Business logic and data operations
  - `Utilities.swift` - Helper functions
- `Assets.xcassets/` - App icons and images
- `Expense_Tracker_FinalTests/` - Unit tests

## Usage
- Launch the app. If you are a new user, onboarding screens will guide you.
- Add expenses using the '+' button on the dashboard.
- View analytics and all expenses from dashboard buttons.
- Modify or delete expenses from the expense rows.

## Testing
- Unit tests are located in `Expense_Tracker_FinalTests/`.
- Run tests in Xcode with Cmd+U.

## License
MIT License

## Author
Aditya Pundlik

---
For questions or issues, open a GitHub issue or contact the author.
