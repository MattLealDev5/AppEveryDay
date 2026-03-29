//
//  Adventure.swift
//  MicroAdventures
//

import CoreLocation
import SwiftUI

struct Adventure: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let category: Category
    let effortLevel: EffortLevel
    let locationName: String
    let latitude: Double
    let longitude: Double
    var isCompleted: Bool = false

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

enum Category: String, CaseIterable, Identifiable {
    case nature = "Nature"
    case urban = "Urban"
    case water = "Water"
    case food = "Food"
    case cultural = "Cultural"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .nature: "leaf.fill"
        case .urban: "building.2.fill"
        case .water: "drop.fill"
        case .food: "fork.knife"
        case .cultural: "theatermasks.fill"
        }
    }

    var color: Color {
        switch self {
        case .nature: .green
        case .urban: .gray
        case .water: .blue
        case .food: .orange
        case .cultural: .purple
        }
    }
}

enum EffortLevel: String, CaseIterable, Identifiable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .low: "figure.walk"
        case .medium: "figure.hiking"
        case .high: "figure.climbing"
        }
    }

    var color: Color {
        switch self {
        case .low: .green
        case .medium: .yellow
        case .high: .red
        }
    }
}
