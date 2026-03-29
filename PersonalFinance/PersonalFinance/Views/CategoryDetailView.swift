import SwiftUI
import Charts

struct CategoryDetailView: View {
    let category: Category

    private var dailySpending: [(date: Date, amount: Double)] {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!

        var dailyTotals: [Date: Double] = [:]

        // Initialize all days of the month so far
        var currentDay = startOfMonth
        while currentDay <= now {
            let dayStart = calendar.startOfDay(for: currentDay)
            dailyTotals[dayStart] = 0
            currentDay = calendar.date(byAdding: .day, value: 1, to: currentDay)!
        }

        // Sum transactions per day
        for transaction in category.transactionsThisMonth {
            let dayStart = calendar.startOfDay(for: transaction.date)
            dailyTotals[dayStart, default: 0] += transaction.amount
        }

        return dailyTotals
            .map { (date: $0.key, amount: $0.value) }
            .sorted { $0.date < $1.date }
    }

    private var cumulativeSpending: [(date: Date, total: Double)] {
        var cumulative: Double = 0
        return dailySpending.map { entry in
            cumulative += entry.amount
            return (date: entry.date, total: cumulative)
        }
    }

    var body: some View {
        List {
            Section {
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Spent")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(category.spentThisMonth, format: .currency(code: "USD"))
                                .font(.title2.bold())
                                .foregroundStyle(category.isOverBudget ? .red : .primary)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("Budget")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(category.monthlyBudget, format: .currency(code: "USD"))
                                .font(.title2.bold())
                        }
                    }

                    BudgetProgressBar(spent: category.spentThisMonth, budget: category.monthlyBudget)

                    HStack {
                        if category.isOverBudget {
                            Label(
                                "\(abs(category.remainingBudget), format: .currency(code: "USD")) over budget",
                                systemImage: "exclamationmark.triangle.fill"
                            )
                            .font(.caption)
                            .foregroundStyle(.red)
                        } else {
                            Text("\(category.remainingBudget, format: .currency(code: "USD")) remaining")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("\(Int(category.budgetUtilization * 100))% used")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }

            if !cumulativeSpending.isEmpty {
                Section("Spending Trend") {
                    Chart(cumulativeSpending, id: \.date) { entry in
                        LineMark(
                            x: .value("Date", entry.date, unit: .day),
                            y: .value("Total", entry.total)
                        )
                        .foregroundStyle(category.color)
                        .interpolationMethod(.catmullRom)

                        AreaMark(
                            x: .value("Date", entry.date, unit: .day),
                            y: .value("Total", entry.total)
                        )
                        .foregroundStyle(
                            category.color.opacity(0.1)
                        )
                        .interpolationMethod(.catmullRom)

                        RuleMark(y: .value("Budget", category.monthlyBudget))
                            .foregroundStyle(.red.opacity(0.5))
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                            .annotation(position: .top, alignment: .trailing) {
                                Text("Budget")
                                    .font(.caption2)
                                    .foregroundStyle(.red.opacity(0.7))
                            }
                    }
                    .frame(height: 200)
                    .padding(.vertical, 4)
                }
            }

            Section("Transactions This Month") {
                if category.transactionsThisMonth.isEmpty {
                    Text("No transactions yet")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(category.transactionsThisMonth.sorted(by: { $0.date > $1.date })) { transaction in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(transaction.amount, format: .currency(code: "USD"))
                                    .font(.body.bold())
                                if !transaction.note.isEmpty {
                                    Text(transaction.note)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                            Text(transaction.date, format: .dateTime.month(.abbreviated).day())
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(category.name)
    }
}
