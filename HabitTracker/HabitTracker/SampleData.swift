//
//  SampleData.swift
//  HabitTracker
//

import Foundation
import SwiftUI
import SwiftData

struct SampleData: PreviewModifier {
    static func makeSharedContext() throws -> ModelContainer {
        let schema = Schema([Habit.self, HabitLog.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: config)
        insertSampleData(into: container.mainContext)
        return container
    }

    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }

    @MainActor
    static func insertSampleData(into context: ModelContext) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // Create habits with different colors and frequencies
        let exercise = Habit(name: "Exercise", color: .red, frequency: .daily)
        let reading = Habit(name: "Read 30 min", color: .blue, frequency: .daily)
        let meditate = Habit(name: "Meditate", color: .purple, frequency: .daily)
        let journal = Habit(name: "Journal", color: .green, frequency: .daily)
        let guitar = Habit(name: "Practice Guitar", color: .orange, frequency: .weekly)

        let habits = [exercise, reading, meditate, journal, guitar]

        for habit in habits {
            context.insert(habit)
        }

        // Add completion logs for exercise (5-day streak including today)
        for dayOffset in 0..<5 {
            if let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) {
                let log = HabitLog(date: date, habit: exercise)
                context.insert(log)
            }
        }

        // Add logs for reading (3-day streak, completed today)
        for dayOffset in 0..<3 {
            if let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) {
                let log = HabitLog(date: date, habit: reading)
                context.insert(log)
            }
        }
        // Add some older reading logs
        for dayOffset in [5, 6, 8, 10] {
            if let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) {
                let log = HabitLog(date: date, habit: reading)
                context.insert(log)
            }
        }

        // Add logs for meditation (streak broken yesterday, only today)
        let meditateLog = HabitLog(date: today, habit: meditate)
        context.insert(meditateLog)
        for dayOffset in [3, 4, 5] {
            if let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) {
                let log = HabitLog(date: date, habit: meditate)
                context.insert(log)
            }
        }

        // Journal has sporadic completions (not today)
        for dayOffset in [1, 3, 5, 7, 9, 12] {
            if let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) {
                let log = HabitLog(date: date, habit: journal)
                context.insert(log)
            }
        }

        // Guitar: weekly, a few logs
        for dayOffset in [0, 7, 14] {
            if let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) {
                let log = HabitLog(date: date, habit: guitar)
                context.insert(log)
            }
        }
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleData: Self = .modifier(SampleData())
}
