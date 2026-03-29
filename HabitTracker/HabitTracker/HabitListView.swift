//
//  HabitListView.swift
//  HabitTracker
//

import SwiftUI
import SwiftData

struct HabitListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.creationDate) private var habits: [Habit]
    @State private var showingAddHabit = false

    var body: some View {
        NavigationStack {
            Group {
                if habits.isEmpty {
                    emptyStateView
                } else {
                    habitList
                }
            }
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddHabit = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                AddEditHabitView()
            }
        }
    }

    // MARK: - Subviews

    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("No Habits", systemImage: "list.bullet.clipboard")
        } description: {
            Text("Tap the + button to add your first habit.")
        }
    }

    private var habitList: some View {
        List {
            ForEach(habits) { habit in
                NavigationLink(value: habit) {
                    HabitRowView(habit: habit, onToggle: {
                        toggleCompletion(for: habit)
                    })
                }
            }
            .onDelete(perform: deleteHabits)
        }
        .navigationDestination(for: Habit.self) { habit in
            HabitDetailView(habit: habit)
        }
    }

    // MARK: - Actions

    private func toggleCompletion(for habit: Habit) {
        if let existingLog = habit.logForToday() {
            modelContext.delete(existingLog)
        } else {
            let log = HabitLog(habit: habit)
            modelContext.insert(log)
        }
    }

    private func deleteHabits(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(habits[index])
        }
    }
}

// MARK: - Habit Row

struct HabitRowView: View {
    let habit: Habit
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Completion toggle button
            Button {
                onToggle()
            } label: {
                Image(systemName: habit.isCompletedToday() ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(habit.isCompletedToday() ? habit.color.swiftUIColor : .gray)
            }
            .buttonStyle(.plain)

            // Color indicator
            Circle()
                .fill(habit.color.swiftUIColor)
                .frame(width: 10, height: 10)

            // Habit info
            VStack(alignment: .leading, spacing: 2) {
                Text(habit.name)
                    .font(.body)
                    .strikethrough(habit.isCompletedToday(), color: .secondary)

                HStack(spacing: 8) {
                    Text(habit.frequency.rawValue)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    let streak = habit.currentStreak()
                    if streak > 0 {
                        Label("\(streak) day streak", systemImage: "flame.fill")
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }
                }
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview(traits: .sampleData) {
    HabitListView()
}
