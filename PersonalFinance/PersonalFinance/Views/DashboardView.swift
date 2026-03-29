import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Category.sortOrder) private var categories: [Category]

    @State private var viewModel = DashboardViewModel()

    var body: some View {
        NavigationStack {
            List {
                // Monthly Summary
                Section {
                    VStack(spacing: 12) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Total Spent")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(viewModel.totalSpentThisMonth(categories: categories), format: .currency(code: "USD"))
                                    .font(.title.bold())
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("Total Budget")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(viewModel.totalBudget(categories: categories), format: .currency(code: "USD"))
                                    .font(.title3)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        let totalSpent = viewModel.totalSpentThisMonth(categories: categories)
                        let totalBudget = viewModel.totalBudget(categories: categories)
                        BudgetProgressBar(spent: totalSpent, budget: totalBudget)

                        HStack {
                            let remaining = totalBudget - totalSpent
                            if remaining >= 0 {
                                Text("\(remaining, format: .currency(code: "USD")) remaining")
                                    .font(.caption)
                                    .foregroundStyle(.green)
                            } else {
                                Label(
                                    "\(abs(remaining), format: .currency(code: "USD")) over budget",
                                    systemImage: "exclamationmark.triangle.fill"
                                )
                                .font(.caption)
                                .foregroundStyle(.red)
                            }
                            Spacer()
                            Text(currentMonthName)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }

                // Categories
                Section("Categories") {
                    if categories.isEmpty {
                        HStack {
                            Spacer()
                            VStack(spacing: 8) {
                                Image(systemName: "folder.badge.plus")
                                    .font(.largeTitle)
                                    .foregroundStyle(.secondary)
                                Text("No categories yet")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Button("Add Category") {
                                    viewModel.showingCategoryManagement = true
                                }
                                .buttonStyle(.borderedProminent)
                                .controlSize(.small)
                            }
                            .padding(.vertical)
                            Spacer()
                        }
                    } else {
                        ForEach(categories) { category in
                            NavigationLink(value: category) {
                                CategoryRow(category: category)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Finance Tracker")
            .navigationDestination(for: Category.self) { category in
                CategoryDetailView(category: category)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.showingAddTransaction = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingAddTransaction) {
                AddTransactionView()
            }
            .sheet(isPresented: $viewModel.showingCategoryManagement) {
                NavigationStack {
                    CategoryManagementView()
                }
            }
        }
    }

    private var currentMonthName: String {
        Date.now.formatted(.dateTime.month(.wide).year())
    }
}

struct CategoryRow: View {
    let category: Category

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: category.iconName)
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(category.color)
                )

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(category.name)
                        .font(.body)
                    Spacer()
                    Text(category.spentThisMonth, format: .currency(code: "USD"))
                        .font(.body.bold())
                        .foregroundStyle(category.isOverBudget ? .red : .primary)
                }

                HStack {
                    BudgetProgressBar(spent: category.spentThisMonth, budget: category.monthlyBudget)

                    Text("/ \(category.monthlyBudget, format: .currency(code: "USD"))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize()
                }
            }

            if category.isOverBudget {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)
                    .font(.caption)
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview(traits: .sampleData) {
    DashboardView()
}
