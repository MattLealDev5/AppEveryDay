//
//  Coffee.swift
//  CoffeeDelivery
//

import Foundation

// MARK: - Coffee Category

enum CoffeeCategory: String, CaseIterable, Identifiable, Sendable {
    case traditional = "Tradicionais"
    case sweet       = "Doces"
    case special     = "Especiais"
    var id: String { rawValue }
}

// MARK: - Coffee Model

struct Coffee: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let description: String
    let price: String
    let category: CoffeeCategory
    let imageName: String

    init(
        id: String = UUID().uuidString,
        name: String,
        description: String,
        price: String,
        category: CoffeeCategory,
        imageName: String
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.category = category
        self.imageName = imageName
    }
}

// MARK: - Sample Data

extension Coffee {
    static let allCoffees: [Coffee] = [
        .init(
            name: "Expresso Tradicional",
            description: "O tradicional café feito com água quente e grãos moídos",
            price: "9,90",
            category: .traditional,
            imageName: "55b1f9ee64600f98b2bae456b96fdc624c4b4f47"
        ),
        .init(
            name: "Expresso Americano",
            description: "Expresso diluído, menos intenso que o tradicional",
            price: "9,90",
            category: .traditional,
            imageName: "446216dc20b9de473c3aadc304466df059e1887e"
        ),
        .init(
            name: "Expresso Cremoso",
            description: "Café expresso tradicional com espuma cremosa",
            price: "9,90",
            category: .traditional,
            imageName: "0a3c95869a75d3fa0ffdecc4bc46ca83d2342e1c"
        ),
        .init(
            name: "Latte",
            description: "Café expresso com o dobro de leite e espuma cremosa",
            price: "9,90",
            category: .traditional,
            imageName: "bcfa72ad62a8600eeded092c17fd14240624545e"
        ),
        .init(
            name: "Expresso Gelado",
            description: "Bebida preparada com café expresso e cubos de gelo",
            price: "9,90",
            category: .traditional,
            imageName: "96a1748f55962d2032bd0e2555d1261409dbd24d"
        ),
        .init(
            name: "Capuccino",
            description: "Bebida com canela feita de doses de café, leite e espuma",
            price: "9,90",
            category: .sweet,
            imageName: "669381b70a9565b6f322ac8b5229ee4fc4b47825"
        ),
        .init(
            name: "Mocaccino",
            description: "Café expresso com calda de chocolate, pouco leite e espuma",
            price: "9,90",
            category: .sweet,
            imageName: "bc3e4798837b2a3ba5d0fa098e7e39985025efb7"
        ),
        .init(
            name: "Chocolate Quente",
            description: "Bebida feita com chocolate dissolvido no leite quente e café",
            price: "9,90",
            category: .sweet,
            imageName: "53b99cd5c0cac4ecf7b9bd81c976cdd9fe2ab3a3"
        ),
        .init(
            name: "Cubano",
            description: "Drink gelado de café expresso com rum, creme de leite e hortelã",
            price: "9,90",
            category: .special,
            imageName: "64fd9a26b6d3187556021c2da9fc80f2da41088f"
        ),
        .init(
            name: "Havaiano",
            description: "Bebida adocicada preparada com café e leite de coco",
            price: "9,90",
            category: .special,
            imageName: "890a8773a655c4fabfc9a7ecdc389e6ea93587ac"
        ),
        .init(
            name: "Árabe",
            description: "Bebida preparada com grãos de café árabe e especiarias",
            price: "9,90",
            category: .special,
            imageName: "b6af775daaa94dcb37dfe1ee6535aae5b9356e9a"
        ),
        .init(
            name: "Irlandês",
            description: "Bebida a base de café, uísque irlandês, açúcar e chantilly",
            price: "9,90",
            category: .special,
            imageName: "8bcb3d337b04857330d98e72e67bde570cbc8963"
        ),
    ]

    /// The three featured coffees shown in the carousel.
    static let featured: [Coffee] = [
        allCoffees.first { $0.name == "Latte" }!,
        allCoffees.first { $0.name == "Mocaccino" }!,
        allCoffees.first { $0.name == "Irlandês" }!,
    ]
}
