//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by Matthew Leal on 3/8/26.
//

import SwiftUI
import SwiftData

@main
struct HabitTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Habit.self)
    }
}
