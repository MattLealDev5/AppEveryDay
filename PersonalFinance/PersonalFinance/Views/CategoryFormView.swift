import SwiftUI
import SwiftData

struct CategoryFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel = CategoryFormViewModel()
    @State private var showingSymbolPicker = false

    let editingCategory: Category?
    let categoryCount: Int

    init(editingCategory: Category? = nil, categoryCount: Int = 0) {
        self.editingCategory = editingCategory
        self.categoryCount = categoryCount
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Category name", text: $viewModel.name)
                }

                Section("Monthly Budget") {
                    HStack {
                        Text("$")
                            .foregroundStyle(.secondary)
                        CurrencyField(title: "0.00", value: $viewModel.monthlyBudget)
                    }
                }

                Section("Icon") {
                    Button {
                        showingSymbolPicker = true
                    } label: {
                        HStack {
                            Image(systemName: viewModel.iconName)
                                .font(.title2)
                                .foregroundStyle(Color(hex: viewModel.colorHex))
                                .frame(width: 40, height: 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(hex: viewModel.colorHex).opacity(0.15))
                                )
                            Spacer()
                            Text("Change Icon")
                                .foregroundStyle(.secondary)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                }

                Section("Color") {
                    ColorPickerGrid(selectedHex: $viewModel.colorHex)
                        .padding(.vertical, 4)
                }
            }
            .navigationTitle(editingCategory == nil ? "New Category" : "Edit Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.save(
                            context: modelContext,
                            existingCategory: editingCategory,
                            sortOrder: categoryCount
                        )
                        dismiss()
                    }
                    .disabled(!viewModel.isValid)
                }
            }
            .sheet(isPresented: $showingSymbolPicker) {
                SymbolPickerView(selectedSymbol: $viewModel.iconName)
            }
            .onAppear {
                if let category = editingCategory {
                    viewModel.loadFromCategory(category)
                }
            }
        }
    }
}

#Preview("New Category") {
    CategoryFormView()
}
