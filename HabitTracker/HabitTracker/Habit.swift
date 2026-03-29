//
//  Habit.swift
//  HabitTracker
//

import Foundation
import SwiftData

enum HabitFrequency: String, Codable, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
}

enum HabitColor: String, Codable, CaseIterable, Identifiable {
    case red, orange, yellow, green, blue, purple, pink

    var id: String { rawValue }

    var displayName: String { rawValue.capitalized }
}

@Model
final class Habit {
    var name: String
    var colorRaw: String
    var creationDate: Date
    var frequencyRaw: String

    @Relationship(deleteRule: .cascade, inverse: \HabitLog.habit)
    var logs: [HabitLog] = []

    var color: HabitColor {
        get { HabitColor(rawValue: colorRaw) ?? .blue }
        set { colorRaw = newValue.rawValue }
    }

    var frequency: HabitFrequency {
        get { HabitFrequency(rawValue: frequencyRaw) ?? .daily }
        set { frequencyRaw = newValue.rawValue }
    }

    init(name: String, color: HabitColor = .blue, frequency: HabitFrequency = .daily) {
        self.name = name
        self.colorRaw = color.rawValue
        self.frequencyRaw = frequency.rawValue
        self.creationDate = Date()
    }

    // MARK: - Computed Properties

    func isCompletedToday(calendar: Calendar = .current) -> Bool {
        logs.contains { calendar.isDateInToday($0.date) }
    }

    func isCompleted(on date: Date, calendar: Calendar = .current) -> Bool {
        logs.contains { calendar.isDate($0.date, inSameDayAs: date) }
    }

    func currentStreak(calendar: Calendar = .current) -> Int {
        let today = calendar.startOfDay(for: Date())
        let sortedDates = logs
            .map { calendar.startOfDay(for: $0.date) }
            .sorted(by: >)

        guard !sortedDates.isEmpty else { return 0 }

        var streak = 0
        var expectedDate = today

        // If not completed today, start checking from yesterday
        if !sortedDates.contains(today) {
            expectedDate = calendar.date(byAdding: .day, value: -1, to: today)!
        }

        for date in sortedDates {
            if date == expectedDate {
                streak += 1
                expectedDate = calendar.date(byAdding: .day, value: -1, to: expectedDate)!
            } else if date < expectedDate {
                break
            }
        }

        return streak
    }

    var totalCompletions: Int {
        logs.count
    }

    func logForToday(calendar: Calendar = .current) -> HabitLog? {
        logs.first { calendar.isDateInToday($0.date) }
    }
}
