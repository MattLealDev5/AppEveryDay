import Foundation
import SwiftData

@Model
final class Transaction {
    var amount: Double
    var date: Date
    var note: String
    var category: Category?

    init(amount: Double, date: Date = .now, note: String = "", category: Category? = nil) {
        self.amount = amount
        self.date = date
        self.note = note
        self.category = category
    }
}
