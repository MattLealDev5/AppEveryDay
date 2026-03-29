import Foundation
import SwiftData
import SwiftUI

struct SampleData: PreviewModifier {
    static func makeSharedContext() throws -> ModelContainer {
        let schema = Schema([Category.self, Transaction.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [config])
        seedData(context: container.mainContext)
        return container
    }

    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }

    @MainActor
    static func seedIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<Category>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }
        seedData(context: context)
    }

    private static func seedData(context: ModelContext) {
        let categories = defaultCategories()
        for category in categories {
            context.insert(category)
        }

        let calendar = Calendar.current
        let now = Date()

        // Generate sample transactions for this month
        let sampleTransactions: [(amount: Double, daysAgo: Int, note: String, categoryIndex: Int)] = [
            (45.67, 1, "Weekly groceries", 0),
            (12.99, 2, "Lunch with team", 1),
            (89.50, 2, "Target run", 4),
            (35.00, 3, "Gas", 2),
            (15.99, 4, "Netflix", 3),
            (28.45, 5, "Trader Joe's", 0),
            (42.00, 6, "Dinner date", 1),
            (8.50, 7, "Coffee and pastry", 1),
            (55.00, 8, "Uber rides", 2),
            (22.99, 9, "Book purchase", 4),
            (67.80, 10, "Costco", 0),
            (19.99, 11, "Spotify + Hulu", 3),
            (31.50, 12, "Sushi takeout", 1),
            (75.00, 13, "New shoes", 4),
            (38.90, 14, "Grocery haul", 0),
        ]

        for data in sampleTransactions {
            guard data.categoryIndex < categories.count else { continue }
            let date = calendar.date(byAdding: .day, value: -data.daysAgo, to: now)!
            let transaction = Transaction(
                amount: data.amount,
                date: date,
                note: data.note,
                category: categories[data.categoryIndex]
            )
            context.insert(transaction)
        }
    }

    static func defaultCategories() -> [Category] {
        [
            Category(name: "Groceries", colorHex: "2ECC71", monthlyBudget: 400, iconName: "cart.fill", sortOrder: 0),
            Category(name: "Dining", colorHex: "E67E22", monthlyBudget: 200, iconName: "fork.knife", sortOrder: 1),
            Category(name: "Transport", colorHex: "3498DB", monthlyBudget: 150, iconName: "car.fill", sortOrder: 2),
            Category(name: "Entertainment", colorHex: "9B59B6", monthlyBudget: 100, iconName: "film.fill", sortOrder: 3),
            Category(name: "Shopping", colorHex: "E74C3C", monthlyBudget: 250, iconName: "bag.fill", sortOrder: 4),
        ]
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleData: Self = .modifier(SampleData())
}
