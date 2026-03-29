import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct AppColors {
    static let presets: [(name: String, hex: String)] = [
        ("Red", "E74C3C"),
        ("Orange", "E67E22"),
        ("Yellow", "F1C40F"),
        ("Green", "2ECC71"),
        ("Teal", "1ABC9C"),
        ("Blue", "3498DB"),
        ("Purple", "9B59B6"),
        ("Pink", "E91E90"),
        ("Indigo", "5C6BC0"),
        ("Brown", "795548"),
        ("Gray", "95A5A6"),
        ("Navy", "2C3E50"),
    ]
}

struct AppSymbols {
    static let available: [(name: String, symbol: String)] = [
        ("Cart", "cart.fill"),
        ("Fork & Knife", "fork.knife"),
        ("Car", "car.fill"),
        ("Film", "film.fill"),
        ("Bag", "bag.fill"),
        ("House", "house.fill"),
        ("Heart", "heart.fill"),
        ("Bolt", "bolt.fill"),
        ("Wifi", "wifi"),
        ("Phone", "phone.fill"),
        ("Gift", "gift.fill"),
        ("Airplane", "airplane"),
        ("Book", "book.fill"),
        ("Music", "music.note"),
        ("Gamecontroller", "gamecontroller.fill"),
        ("Dumbbell", "dumbbell.fill"),
        ("Cross", "cross.fill"),
        ("Graduationcap", "graduationcap.fill"),
        ("Wrench", "wrench.fill"),
        ("Creditcard", "creditcard.fill"),
        ("Dollarsign", "dollarsign.circle.fill"),
        ("Dog", "dog.fill"),
        ("Tshirt", "tshirt.fill"),
        ("Cup", "cup.and.saucer.fill"),
    ]
}
