import SwiftUI

struct SymbolPickerView: View {
    @Binding var selectedSymbol: String
    @Environment(\.dismiss) private var dismiss

    private let columns = Array(repeating: GridItem(.flexible()), count: 4)

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(AppSymbols.available, id: \.symbol) { item in
                        Button {
                            selectedSymbol = item.symbol
                            dismiss()
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: item.symbol)
                                    .font(.title2)
                                    .frame(width: 50, height: 50)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedSymbol == item.symbol
                                                  ? Color.accentColor.opacity(0.2)
                                                  : Color(.systemGray6))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selectedSymbol == item.symbol
                                                    ? Color.accentColor
                                                    : Color.clear, lineWidth: 2)
                                    )

                                Text(item.name)
                                    .font(.caption2)
                                    .lineLimit(1)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("Choose Icon")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
