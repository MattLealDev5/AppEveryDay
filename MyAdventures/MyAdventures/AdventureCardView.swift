import SwiftUI

struct AdventureCardView: View {
    let adventure: Adventure
    var onDone: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Category and Effort Level row
            HStack {
                Label(adventure.category.rawValue, systemImage: adventure.category.icon)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(categoryColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(categoryColor.opacity(0.15))
                    .clipShape(Capsule())

                Spacer()

                effortIndicator
            }

            // Title
            Text(adventure.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)

            // Description
            Text(adventure.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(3)

            // Done button
            HStack {
                Spacer()
                Button(action: onDone) {
                    Label(
                        adventure.isCompleted ? "Completed" : "Mark Done",
                        systemImage: adventure.isCompleted ? "checkmark.circle.fill" : "checkmark.circle"
                    )
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(adventure.isCompleted ? Color.green : Color.accentColor)
                    .clipShape(Capsule())
                }
                .disabled(adventure.isCompleted)
            }
        }
        .padding(20)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
    }

    // MARK: - Subviews

    private var effortIndicator: some View {
        HStack(spacing: 3) {
            ForEach(1...3, id: \.self) { level in
                Circle()
                    .fill(level <= adventure.effortLevel.rawValue ? Color.orange : Color.orange.opacity(0.2))
                    .frame(width: 8, height: 8)
            }
            Text(adventure.effortLevel.shortLabel)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    private var categoryColor: Color {
        switch adventure.category {
        case .nature: return .green
        case .urban: return .purple
        case .food: return .orange
        case .creative: return .pink
        case .social: return .blue
        case .fitness: return .red
        }
    }
}
