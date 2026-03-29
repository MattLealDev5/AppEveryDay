import SwiftUI
import SwiftData

struct TransactionHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Transaction.date, order: .reverse) private var allTransactions: [Transaction]
    @Query(sort: \Category.sortOrder) private var categories: [Category]

    @State private var selectedCategory: Category?
    @State private var startDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: .now)!
    @State private var endDate: Date = .now
    @State private var showingFilters = false

    private var filteredTransactions: [Transaction] {
        allTransactions.filter { transaction in
            let dateMatch = transaction.date >= Calendar.current.startOfDay(for: startDate)
                && transaction.date <= Calendar.current.date(byAdding: .day, value: 1, to: endDate)!
            let categoryMatch = selectedCategory == nil || transaction.category === selectedCategory
            return dateMatch && categoryMatch
        }
    }

    private var groupedTransactions: [(date: Date, transactions: [Transaction])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredTransactions) { transaction in
            calendar.startOfDay(for: transaction.date)
        }
        return grouped
            .map { (date: $0.key, transactions: $0.value) }
            .sorted { $0.date > $1.date }
    }

    var body: some View {
        List {
            if showingFilters {
                Section("Filters") {
                    Picker("Category", selection: $selectedCategory) {
                        Text("All Categories").tag(nil as Category?)
                        ForEach(categories) { category in
                            Label(category.name, systemImage: category.iconName)
                                .tag(category as Category?)
                        }
                    }

                    DatePicker("From", selection: $startDate, displayedComponents: .date)
                    DatePicker("To", selection: $endDate, displayedComponents: .date)

                    Button("Reset Filters") {
                        selectedCategory = nil
                        startDate = Calendar.current.date(byAdding: .month, value: -1, to: .now)!
                        endDate = .now
                    }
                    .foregroundStyle(.red)
                }
            }

            ForEach(groupedTransactions, id: \.date) { group in
                Section {
                    ForEach(group.transactions) { transaction in
                        TransactionRow(transaction: transaction)
                    }
                    .onDelete { offsets in
                        deleteTransactions(from: group.transactions, at: offsets)
                    }
                } header: {
                    Text(group.date, format: .dateTime.weekday(.wide).month(.abbreviated).day().year())
                }
            }
        }
        .navigationTitle("Transactions")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    withAnimation {
                        showingFilters.toggle()
                    }
                } label: {
                    Image(systemName: showingFilters ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                }
            }
        }
        .overlay {
            if filteredTransactions.isEmpty {
                ContentUnavailableView(
                    "No Transactions",
                    systemImage: "tray",
                    description: Text("No transactions match the current filters.")
                )
            }
        }
    }

    private func deleteTransactions(from transactions: [Transaction], at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(transactions[index])
        }
    }
}

struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 12) {
            if let category = transaction.category {
                Image(systemName: category.iconName)
                    .foregroundStyle(.white)
                    .frame(width: 32, height: 32)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(category.color)
                    )
            } else {
                Image(systemName: "questionmark.circle")
                    .foregroundStyle(.secondary)
                    .frame(width: 32, height: 32)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.category?.name ?? "Uncategorized")
                    .font(.body)
                if !transaction.note.isEmpty {
                    Text(transaction.note)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Text(transaction.amount, format: .currency(code: "USD"))
                .font(.body.bold())
        }
    }
}

#Preview(traits: .sampleData) {
    NavigationStack {
        TransactionHistoryView()
    }
}
