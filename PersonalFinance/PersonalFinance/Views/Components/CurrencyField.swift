import SwiftUI

struct CurrencyField: View {
    let title: String
    @Binding var value: Double

    @State private var text: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        TextField(title, text: $text)
            .keyboardType(.decimalPad)
            .focused($isFocused)
            .onChange(of: text) { _, newValue in
                let filtered = newValue.filter { $0.isNumber || $0 == "." }
                if filtered != newValue {
                    text = filtered
                }
                value = Double(filtered) ?? 0
            }
            .onAppear {
                if value > 0 {
                    text = String(format: "%.2f", value)
                }
            }
    }
}
