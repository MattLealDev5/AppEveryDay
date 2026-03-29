import Foundation
import SwiftData
import Observation

@Observable
final class DashboardViewModel {
    var showingAddTransaction = false
    var showingCategoryManagement = false

    func totalSpentThisMonth(categories: [Category]) -> Double {
        categories.reduce(0) { $0 + $1.spentThisMonth }
    }

    func totalBudget(categories: [Category]) -> Double {
        categories.reduce(0) { $0 + $1.monthlyBudget }
    }

    func deleteCategory(_ category: Category, context: ModelContext) {
        context.delete(category)
    }
}
