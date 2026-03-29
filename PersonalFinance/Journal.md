# PersonalFinance - Engineering Journal

## The Big Picture

Think of this app as your financial conscience in your pocket. You set up categories for how you spend money (groceries, dining out, that sneaky online shopping habit), give each one a monthly budget, and then log your expenses as they happen. The app shows you, in real-time, how close you are to blowing through each budget. Red warning? You've gone overboard. Green progress bar? You're doing great.

It's intentionally simple -- no bank syncing, no investment tracking, no crypto portfolio nonsense. Just honest, manual expense tracking that makes you *think* before you spend.

## Architecture Deep Dive

Picture a restaurant:

- **The Menu (Models)**: `Category` and `Transaction` are the two core ingredients. A Category is like a section on the menu (appetizers, entrees, desserts), and Transactions are the individual dishes. Each dish belongs to exactly one section. SwiftData handles the relationship, and if you delete a section, all its dishes go with it (cascade delete).

- **The Waitstaff (ViewModels)**: Three view models act as intermediaries. `DashboardViewModel` aggregates the totals. `TransactionViewModel` handles the "add expense" form state. `CategoryFormViewModel` manages creating/editing categories. They don't touch the database directly -- they just prepare data and pass it through.

- **The Dining Room (Views)**: A three-tab layout. Dashboard is the main stage where you see your budget health at a glance. Transactions is the receipt drawer. Categories is the back office where you manage your budget structure.

## The Codebase Map

```
PersonalFinance/
├── Models/
│   ├── Category.swift        # Budget category with computed spending properties
│   ├── Transaction.swift     # Individual expense entry
│   └── SampleData.swift      # First-launch seed data
├── ViewModels/
│   ├── DashboardViewModel.swift    # Aggregates category totals
│   ├── TransactionViewModel.swift  # Add transaction form state
│   └── CategoryFormViewModel.swift # Add/edit category form state
├── Views/
│   ├── DashboardView.swift         # Main budget overview
│   ├── AddTransactionView.swift    # Sheet to log expenses
│   ├── CategoryManagementView.swift # CRUD for categories
│   ├── CategoryDetailView.swift    # Deep dive with Charts
│   ├── CategoryFormView.swift      # Add/edit category form
│   ├── TransactionHistoryView.swift # Filterable transaction list
│   └── Components/
│       ├── BudgetProgressBar.swift  # Linear + ring progress indicators
│       ├── ColorPickerGrid.swift    # Preset color palette
│       ├── SymbolPickerView.swift   # SF Symbol browser
│       ├── CurrencyField.swift      # Decimal-only text input
│       └── ColorExtension.swift     # Hex color conversion + presets
├── ContentView.swift         # Tab bar root
└── PersonalFinanceApp.swift  # App entry + SwiftData container
```

## Tech Stack & Why

- **SwiftUI** -- Because declarative UI is the future, and this app is pure UI-driven state management. No UIKit baggage needed.
- **SwiftData** -- Apple's modern persistence framework. We chose it over Core Data because the `@Model` macro eliminates boilerplate, `@Query` gives us reactive data fetching, and relationships "just work."
- **Swift Charts** -- Native charting framework. CategoryDetailView uses `LineMark` and `AreaMark` to show cumulative spending over the month with a dashed `RuleMark` for the budget line.
- **`@Observable` macro** -- Chose this over Combine's `ObservableObject` because it's simpler, doesn't require `@Published` on every property, and integrates better with SwiftUI's observation system.

## The Journey

### Day 1 - Initial Build

**The ForEach-inside-Picker Confusion**: When building the category selector in AddTransactionView, I initially used a `ForEach` with manual `Button` views and `===` identity checks. The Swift compiler threw cascading type errors that looked like they were about `Binding<C>` generics -- completely misleading. The fix was switching to a proper `Picker` with `.pickerStyle(.inline)`, which is both more idiomatic and avoids the type inference rabbit hole.

**Lesson learned**: When Swift gives you bizarre generic errors in a `ForEach`, the problem is often that the compiler is trying to match a different overload than you expect. Use the more specific API.

**Color Persistence**: SwiftUI's `Color` type doesn't conform to `Codable`, so you can't store it directly in SwiftData. The solution is storing hex strings and converting with an extension. It's a well-known pattern, but it's the kind of thing that trips you up if you haven't hit it before.

## Engineer's Wisdom

1. **Computed properties on models are powerful**: `Category.spentThisMonth`, `budgetUtilization`, `isOverBudget` -- these live on the model and compute from the relationship. No need for a separate service layer.

2. **Cascade delete rules matter**: Setting `.cascade` on the Category -> Transaction relationship means deleting a category cleans up its transactions. Without this, you'd have orphaned data.

3. **Separate form state from persistence**: The `CategoryFormViewModel` holds form state independently. It only touches the model context on save. This prevents half-edited data from leaking into the persistent store.

4. **Seed data should be idempotent**: `SampleData.seedIfNeeded` checks if categories exist before seeding. Running it twice won't duplicate data.

## If I Were Starting Over...

- **Consider a `BudgetPeriod` model**: Right now, "this month" is hardcoded via date filtering. A dedicated period model would support historical month-over-month comparisons.
- **Add recurring transactions**: Many expenses (subscriptions, rent) repeat monthly. An auto-generation system would reduce manual entry.
- **Export/import**: CSV or JSON export would make the data portable.
- **Widget support**: A home screen widget showing budget status would increase daily engagement without opening the app.
