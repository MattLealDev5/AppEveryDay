import SwiftUI

struct BudgetProgressBar: View {
    let spent: Double
    let budget: Double

    private var progress: Double {
        guard budget > 0 else { return 0 }
        return min(spent / budget, 1.0)
    }

    private var isOverBudget: Bool {
        spent > budget
    }

    private var progressColor: Color {
        if isOverBudget { return .red }
        if progress > 0.8 { return .orange }
        return .green
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray5))

                RoundedRectangle(cornerRadius: 4)
                    .fill(progressColor)
                    .frame(width: geometry.size.width * progress)
            }
        }
        .frame(height: 8)
    }
}

struct BudgetRing: View {
    let spent: Double
    let budget: Double
    let size: CGFloat

    private var progress: Double {
        guard budget > 0 else { return 0 }
        return min(spent / budget, 1.0)
    }

    private var isOverBudget: Bool {
        spent > budget
    }

    private var ringColor: Color {
        if isOverBudget { return .red }
        if progress > 0.8 { return .orange }
        return .green
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 4)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(ringColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))

            if isOverBudget {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)
                    .font(.system(size: size * 0.3))
            }
        }
        .frame(width: size, height: size)
    }
}
