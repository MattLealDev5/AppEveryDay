import SwiftUI
import SwiftData

struct AddTransactionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Category.sortOrder) private var categories: [Category]

    @State private var viewModel = TransactionViewModel()

    var body: some View {
        NavigationStack {
            Form {
                Section("Amount") {
                    HStack {
                        Text("$")
                            .foregroundStyle(.secondary)
                        CurrencyField(title: "0.00", value: $viewModel.amount)
                    }
                }

                Section("Category") {
                    if categories.isEmpty {
                        Text("No categories yet. Add one first.")
                            .foregroundStyle(.secondary)
                    } else {
                        Picker("Category", selection: $viewModel.selectedCategory) {
                            Text("Select a category").tag(nil as Category?)
                            ForEach(categories) { category in
                                Label(category.name, systemImage: category.iconName)
                                    .tag(category as Category?)
                            }
                        }
                        .pickerStyle(.inline)
                        .labelsHidden()
                    }
                }

                Section("Date") {
                    DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                }

                Section("Note") {
                    TextField("Optional note", text: $viewModel.note)
                }
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.save(context: modelContext)
                        dismiss()
                    }
                    .disabled(!viewModel.isValid)
                }
            }
        }
    }
}

#Preview(traits: .sampleData) {
    AddTransactionView()
}
