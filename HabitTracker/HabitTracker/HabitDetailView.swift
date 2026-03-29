//
//  HabitDetailView.swift
//  HabitTracker
//

import SwiftUI
import SwiftData

struct HabitDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let habit: Habit

    @State private var showingEditSheet = false

    private let calendar = Calendar.current
    private let daysToShow = 14

    var body: some View {
        List {
            statsSection
            calendarSection
            recentHistorySection
        }
        .navigationTitle(habit.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    showingEditSheet = true
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            AddEditHabitView(habitToEdit: habit)
        }
    }

    // MARK: - Stats Section

    private var statsSection: some View {
        Section("Statistics") {
            HStack {
                StatCard(
                    title: "Current Streak",
                    value: "\(habit.currentStreak())",
                    unit: "days",
                    icon: "flame.fill",
                    color: .orange
                )

                StatCard(
                    title: "Total",
                    value: "\(habit.totalCompletions)",
                    unit: "completions",
                    icon: "checkmark.circle.fill",
                    color: habit.color.swiftUIColor
                )
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        }
    }

    // MARK: - Calendar Grid Section

    private var calendarSection: some View {
        Section("Last \(daysToShow) Days") {
            let days = lastNDays(daysToShow)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(days, id: \.self) { date in
                    VStack(spacing: 4) {
                        Text(dayOfWeekLabel(for: date))
                            .font(.caption2)
                            .foregroundStyle(.secondary)

                        ZStack {
                            Circle()
                                .fill(habit.isCompleted(on: date)
                                      ? habit.color.swiftUIColor
                                      : Color(.systemGray5))
                                .frame(width: 32, height: 32)

                            if habit.isCompleted(on: date) {
                                Image(systemName: "checkmark")
                                    .font(.caption.bold())
                                    .foregroundStyle(.white)
                            } else {
                                Text(dayNumberLabel(for: date))
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onTapGesture {
                        toggleCompletion(for: date)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }

    // MARK: - Recent History Section

    private var recentHistorySection: some View {
        Section("Completion History") {
            let sortedLogs = habit.logs.sorted { $0.date > $1.date }

            if sortedLogs.isEmpty {
                Text("No completions yet")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(sortedLogs.prefix(20), id: \.id) { log in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(habit.color.swiftUIColor)
                        Text(log.date, format: .dateTime.weekday(.wide).month(.abbreviated).day())
                        Spacer()
                        Text(log.date, format: .dateTime.hour().minute())
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    // MARK: - Helpers

    private func lastNDays(_ n: Int) -> [Date] {
        (0..<n).compactMap { offset in
            calendar.date(byAdding: .day, value: -offset, to: calendar.startOfDay(for: Date()))
        }.reversed()
    }

    private func dayOfWeekLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return String(formatter.string(from: date).prefix(2))
    }

    private func dayNumberLabel(for date: Date) -> String {
        let day = calendar.component(.day, from: date)
        return "\(day)"
    }

    private func toggleCompletion(for date: Date) {
        if let existingLog = habit.logs.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            modelContext.delete(existingLog)
        } else {
            let log = HabitLog(date: date, habit: habit)
            modelContext.insert(log)
        }
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)

            Text(value)
                .font(.title.bold())

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(4)
    }
}

#Preview(traits: .sampleData) {
    @Previewable @Query var habits: [Habit]
    NavigationStack {
        if let habit = habits.first {
            HabitDetailView(habit: habit)
        }
    }
}
