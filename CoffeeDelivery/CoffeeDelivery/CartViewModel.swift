//
//  CartViewModel.swift
//  CoffeeDelivery
//

import SwiftUI

// MARK: - CoffeeSize (shared across Product & Cart)

enum CoffeeSize: String, CaseIterable, Hashable, Sendable {
    case small  = "114ml"
    case medium = "140ml"
    case large  = "227ml"
}

// MARK: - CartItem

struct CartItem: Identifiable, Hashable {
    let id: String
    let coffee: Coffee
    var quantity: Int
    let size: CoffeeSize

    init(coffee: Coffee, quantity: Int = 1, size: CoffeeSize = .large) {
        self.id = "\(coffee.id)-\(size.rawValue)"
        self.coffee = coffee
        self.quantity = quantity
        self.size = size
    }

    var priceValue: Double {
        Double(coffee.price.replacingOccurrences(of: ",", with: ".")) ?? 0
    }

    var lineTotal: Double { priceValue * Double(quantity) }
}

// MARK: - CartViewModel

@Observable
final class CartViewModel {
    var items: [CartItem] = []
    var showCart = false
    var showOrderConfirmed = false

    /// Total number of individual coffees in the cart.
    var totalCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    var total: Double {
        items.reduce(0) { $0 + $1.lineTotal }
    }

    var formattedTotal: String {
        let s = String(format: "%.2f", total)
        return s.replacingOccurrences(of: ".", with: ",")
    }

    /// Add a coffee with a given size and quantity.
    /// If the same coffee + size already exists, the quantity is increased.
    func add(coffee: Coffee, size: CoffeeSize, quantity: Int) {
        let key = "\(coffee.id)-\(size.rawValue)"
        if let idx = items.firstIndex(where: { $0.id == key }) {
            items[idx].quantity += quantity
        } else {
            items.append(CartItem(coffee: coffee, quantity: quantity, size: size))
        }
    }

    func remove(id: String) {
        items.removeAll { $0.id == id }
    }

    func confirmOrder() {
        items.removeAll()
        showCart = false
        showOrderConfirmed = true
    }
}
