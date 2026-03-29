//
//  HabitLog.swift
//  HabitTracker
//

import Foundation
import SwiftData

@Model
final class HabitLog {
    var date: Date
    var habit: Habit?

    init(date: Date = Date(), habit: Habit) {
        self.date = date
        self.habit = habit
    }
}
