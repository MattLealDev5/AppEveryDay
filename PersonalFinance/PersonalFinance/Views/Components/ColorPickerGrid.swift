import SwiftUI

struct ColorPickerGrid: View {
    @Binding var selectedHex: String

    private let columns = Array(repeating: GridItem(.flexible()), count: 6)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(AppColors.presets, id: \.hex) { preset in
                Circle()
                    .fill(Color(hex: preset.hex))
                    .frame(width: 36, height: 36)
                    .overlay(
                        Circle()
                            .stroke(Color.primary, lineWidth: selectedHex == preset.hex ? 3 : 0)
                            .padding(2)
                    )
                    .overlay(
                        Group {
                            if selectedHex == preset.hex {
                                Image(systemName: "checkmark")
                                    .font(.caption.bold())
                                    .foregroundStyle(.white)
                            }
                        }
                    )
                    .onTapGesture {
                        selectedHex = preset.hex
                    }
            }
        }
    }
}
