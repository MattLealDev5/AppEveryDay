import Foundation
import CoreLocation

// MARK: - Data Model

enum AdventureCategory: String, CaseIterable, Identifiable {
    case nature = "Nature"
    case urban = "Urban"
    case food = "Food"
    case creative = "Creative"
    case social = "Social"
    case fitness = "Fitness"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .nature: return "leaf.fill"
        case .urban: return "building.2.fill"
        case .food: return "fork.knife"
        case .creative: return "paintbrush.fill"
        case .social: return "person.2.fill"
        case .fitness: return "figure.run"
        }
    }

    var color: String {
        switch self {
        case .nature: return "green"
        case .urban: return "purple"
        case .food: return "orange"
        case .creative: return "pink"
        case .social: return "blue"
        case .fitness: return "red"
        }
    }
}

enum EffortLevel: Int, CaseIterable, Identifiable, Comparable {
    case low = 1
    case medium = 2
    case high = 3

    var id: Int { rawValue }

    var label: String {
        switch self {
        case .low: return "Low Effort"
        case .medium: return "Medium Effort"
        case .high: return "High Effort"
        }
    }

    var shortLabel: String {
        switch self {
        case .low: return "Easy"
        case .medium: return "Moderate"
        case .high: return "Challenging"
        }
    }

    static func < (lhs: EffortLevel, rhs: EffortLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

struct Adventure: Identifiable {
    let id = UUID()
    let category: AdventureCategory
    let title: String
    let description: String
    let effortLevel: EffortLevel
    let coordinate: CLLocationCoordinate2D
    var isCompleted: Bool = false
}

// MARK: - Sample Data

extension Adventure {
    static let sampleAdventures: [Adventure] = [
        Adventure(
            category: .nature,
            title: "Sunrise Walk",
            description: "Wake up early and walk to the nearest park to watch the sunrise. Take three deep breaths and notice five things you can see.",
            effortLevel: .medium,
            coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        ),
        Adventure(
            category: .food,
            title: "Mystery Ingredient Cooking",
            description: "Go to a grocery store, pick a random ingredient you've never cooked with, and make a meal using it tonight.",
            effortLevel: .medium,
            coordinate: CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.4094)
        ),
        Adventure(
            category: .urban,
            title: "Photo Scavenger Hunt",
            description: "Walk around your neighborhood and photograph: something red, something old, something that makes you smile, and something tiny.",
            effortLevel: .low,
            coordinate: CLLocationCoordinate2D(latitude: 37.7649, longitude: -122.4294)
        ),
        Adventure(
            category: .creative,
            title: "Sketch a Stranger's Story",
            description: "Sit in a café, pick a stranger, and imagine their life story. Write or draw it in a notebook.",
            effortLevel: .low,
            coordinate: CLLocationCoordinate2D(latitude: 37.7799, longitude: -122.4144)
        ),
        Adventure(
            category: .social,
            title: "Compliment Challenge",
            description: "Give genuine, specific compliments to five different people today. Notice how it changes your mood.",
            effortLevel: .low,
            coordinate: CLLocationCoordinate2D(latitude: 37.7729, longitude: -122.4214)
        ),
        Adventure(
            category: .fitness,
            title: "Stairway Explorer",
            description: "Find the tallest public staircase near you and climb it. Enjoy the view from the top and take a selfie.",
            effortLevel: .high,
            coordinate: CLLocationCoordinate2D(latitude: 37.7689, longitude: -122.4314)
        ),
        Adventure(
            category: .nature,
            title: "Cloud Watching",
            description: "Lie on the grass for 15 minutes and watch the clouds. Try to find shapes and let your mind wander freely.",
            effortLevel: .low,
            coordinate: CLLocationCoordinate2D(latitude: 37.7719, longitude: -122.4174)
        ),
        Adventure(
            category: .urban,
            title: "Get Lost on Purpose",
            description: "Pick a bus or train you've never taken and ride it to the end of the line. Explore the neighborhood for 30 minutes before heading back.",
            effortLevel: .high,
            coordinate: CLLocationCoordinate2D(latitude: 37.7909, longitude: -122.3994)
        ),
        Adventure(
            category: .food,
            title: "International Snack Run",
            description: "Visit an international grocery store and buy three snacks from a country you've never visited. Rate them with friends.",
            effortLevel: .low,
            coordinate: CLLocationCoordinate2D(latitude: 37.7769, longitude: -122.4254)
        ),
        Adventure(
            category: .fitness,
            title: "Barefoot in the Park",
            description: "Take off your shoes at a park and walk barefoot on the grass for 10 minutes. Feel the ground beneath you.",
            effortLevel: .low,
            coordinate: CLLocationCoordinate2D(latitude: 37.7739, longitude: -122.4164)
        ),
    ]
}
