import Foundation
import SwiftData

@Observable
final class CategoryFormViewModel {
    var name: String = ""
    var colorHex: String = "3498DB"
    var monthlyBudget: Double = 0
    var iconName: String = "cart.fill"

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && monthlyBudget > 0
    }

    func loadFromCategory(_ category: Category) {
        name = category.name
        colorHex = category.colorHex
        monthlyBudget = category.monthlyBudget
        iconName = category.iconName
    }

    func save(context: ModelContext, existingCategory: Category? = nil, sortOrder: Int = 0) {
        if let existing = existingCategory {
            existing.name = name.trimmingCharacters(in: .whitespaces)
            existing.colorHex = colorHex
            existing.monthlyBudget = monthlyBudget
            existing.iconName = iconName
        } else {
            let category = Category(
                name: name.trimmingCharacters(in: .whitespaces),
                colorHex: colorHex,
                monthlyBudget: monthlyBudget,
                iconName: iconName,
                sortOrder: sortOrder
            )
            context.insert(category)
        }
    }

    func reset() {
        name = ""
        colorHex = "3498DB"
        monthlyBudget = 0
        iconName = "cart.fill"
    }
}
