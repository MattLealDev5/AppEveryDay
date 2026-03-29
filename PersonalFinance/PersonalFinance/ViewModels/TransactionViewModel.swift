import Foundation
import SwiftData

@Observable
final class TransactionViewModel {
    var amount: Double = 0
    var date: Date = .now
    var note: String = ""
    var selectedCategory: Category?

    var isValid: Bool {
        amount > 0 && selectedCategory != nil
    }

    func save(context: ModelContext) {
        let transaction = Transaction(
            amount: amount,
            date: date,
            note: note,
            category: selectedCategory
        )
        context.insert(transaction)
        reset()
    }

    func reset() {
        amount = 0
        date = .now
        note = ""
        selectedCategory = nil
    }

    func deleteTransaction(_ transaction: Transaction, context: ModelContext) {
        context.delete(transaction)
    }
}
