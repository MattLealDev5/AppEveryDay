import Foundation
import SwiftData
import SwiftUI

@Model
final class Category {
    var name: String
    var colorHex: String
    var monthlyBudget: Double
    var iconName: String
    var sortOrder: Int

    @Relationship(deleteRule: .cascade, inverse: \Transaction.category)
    var transactions: [Transaction] = []

    init(name: String, colorHex: String, monthlyBudget: Double, iconName: String, sortOrder: Int = 0) {
        self.name = name
        self.colorHex = colorHex
        self.monthlyBudget = monthlyBudget
        self.iconName = iconName
        self.sortOrder = sortOrder
    }

    var color: Color {
        Color(hex: colorHex)
    }

    var transactionsThisMonth: [Transaction] {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        return transactions.filter { $0.date >= startOfMonth && $0.date <= endOfMonth }
    }

    var spentThisMonth: Double {
        transactionsThisMonth.reduce(0) { $0 + $1.amount }
    }

    var budgetUtilization: Double {
        guard monthlyBudget > 0 else { return 0 }
        return spentThisMonth / monthlyBudget
    }

    var isOverBudget: Bool {
        spentThisMonth > monthlyBudget
    }

    var remainingBudget: Double {
        monthlyBudget - spentThisMonth
    }
}
