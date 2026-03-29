//
//  AddEditHabitView.swift
//  HabitTracker
//

import SwiftUI
import SwiftData

struct AddEditHabitView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var habitToEdit: Habit?

    @State private var name: String = ""
    @State private var selectedColor: HabitColor = .blue
    @State private var selectedFrequency: HabitFrequency = .daily

    private var isEditing: Bool { habitToEdit != nil }
    private var isFormValid: Bool { !name.trimmingCharacters(in: .whitespaces).isEmpty }

    var body: some View {
        NavigationStack {
            Form {
                Section("Habit Name") {
                    TextField("e.g. Exercise, Read, Meditate", text: $name)
                }

                Section("Color") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                        ForEach(HabitColor.allCases) { color in
                            Circle()
                                .fill(color.swiftUIColor)
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Circle()
                                        .stroke(Color.primary, lineWidth: selectedColor == color ? 3 : 0)
                                        .padding(-3)
                                )
                                .overlay(
                                    selectedColor == color
                                        ? Image(systemName: "checkmark")
                                            .font(.caption.bold())
                                            .foregroundStyle(.white)
                                        : nil
                                )
                                .onTapGesture {
                                    selectedColor = color
                                }
                        }
                    }
                    .padding(.vertical, 4)
                }

                Section("Frequency") {
                    Picker("Target", selection: $selectedFrequency) {
                        ForEach(HabitFrequency.allCases, id: \.self) { frequency in
                            Text(frequency.rawValue).tag(frequency)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle(isEditing ? "Edit Habit" : "New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Save" : "Add") {
                        saveHabit()
                    }
                    .disabled(!isFormValid)
                }
            }
            .onAppear {
                if let habit = habitToEdit {
                    name = habit.name
                    selectedColor = habit.color
                    selectedFrequency = habit.frequency
                }
            }
        }
    }

    private func saveHabit() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)

        if let habit = habitToEdit {
            habit.name = trimmedName
            habit.color = selectedColor
            habit.frequency = selectedFrequency
        } else {
            let habit = Habit(name: trimmedName, color: selectedColor, frequency: selectedFrequency)
            modelContext.insert(habit)
        }

        dismiss()
    }
}

#Preview(traits: .sampleData) {
    AddEditHabitView()
}
