import SwiftUI

struct FilterView: View {
    @Binding var selectedCategories: Set<AdventureCategory>
    @Binding var maxEffort: EffortLevel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                categorySection
                effortSection
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset") {
                        selectedCategories = Set(AdventureCategory.allCases)
                        maxEffort = .high
                    }
                }
            }
        }
    }

    private var categorySection: some View {
        Section("Categories") {
            ForEach(AdventureCategory.allCases) { category in
                CategoryRow(
                    category: category,
                    isSelected: selectedCategories.contains(category),
                    onTap: { toggleCategory(category) }
                )
            }
        }
    }

    private var effortSection: some View {
        Section("Maximum Effort Level") {
            ForEach(EffortLevel.allCases) { level in
                EffortRow(
                    level: level,
                    isSelected: maxEffort == level,
                    onTap: { maxEffort = level }
                )
            }
        }
    }

    private func toggleCategory(_ category: AdventureCategory) {
        if selectedCategories.contains(category) {
            if selectedCategories.count > 1 {
                selectedCategories.remove(category)
            }
        } else {
            selectedCategories.insert(category)
        }
    }
}

// MARK: - Row Views

private struct CategoryRow: View {
    let category: AdventureCategory
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                Label(category.rawValue, systemImage: category.icon)
                    .foregroundStyle(colorFor(category))
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                }
            }
        }
        .tint(.primary)
    }

    private func colorFor(_ category: AdventureCategory) -> Color {
        switch category {
        case .nature: return .green
        case .urban: return .purple
        case .food: return .orange
        case .creative: return .pink
        case .social: return .blue
        case .fitness: return .red
        }
    }
}

private struct EffortRow: View {
    let level: EffortLevel
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                EffortDotsView(level: level)
                Text(level.label)
                    .foregroundStyle(.primary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                }
            }
        }
        .tint(.primary)
    }
}

struct EffortDotsView: View {
    let level: EffortLevel

    var body: some View {
        HStack(spacing: 3) {
            ForEach(1...3, id: \.self) { dot in
                Circle()
                    .fill(dot <= level.rawValue ? Color.orange : Color.orange.opacity(0.2))
                    .frame(width: 8, height: 8)
            }
        }
    }
}
