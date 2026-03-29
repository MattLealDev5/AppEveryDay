# PersonalFinance

## Overview
A personal finance tracker iOS app built with SwiftUI and SwiftData. Users can create budget categories, log expenses, and track spending against monthly budgets with visual charts.

## Architecture
- **MVVM** with SwiftUI + SwiftData
- **Models**: SwiftData `@Model` classes (`Category`, `Transaction`) with a one-to-many relationship (Category -> Transactions)
- **ViewModels**: `@Observable` classes (`DashboardViewModel`, `TransactionViewModel`, `CategoryFormViewModel`)
- **Views**: Tab-based navigation (Dashboard, Transactions, Categories)

## Key Patterns
- `@Query` for declarative SwiftData fetching in views
- `@Observable` macro for view models (not Combine)
- `Tab` API (iOS 18+) for tab bar
- Swift Charts for spending visualization
- Color stored as hex strings in SwiftData, converted via `Color(hex:)` extension

## Build & Run
- Open `PersonalFinance.xcodeproj` in Xcode
- Build target: iOS 18+
- No external dependencies
- Sample data seeds automatically on first launch (5 categories, 15 transactions)

## Gotchas
- `Category` model stores color as `colorHex: String` (not SwiftUI `Color`, which isn't directly persistable in SwiftData)
- `Transaction.category` is optional to handle orphaned transactions gracefully
- The `Tab` initializer requires iOS 18+ (uses new `Tab("title", systemImage:)` syntax)
- `@Model` classes are automatically `Identifiable` and `Hashable` via SwiftData
