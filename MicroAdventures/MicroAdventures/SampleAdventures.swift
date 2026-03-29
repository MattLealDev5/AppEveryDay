//
//  SampleAdventures.swift
//  MicroAdventures
//

import Foundation

extension Adventure {
    static let sampleAdventures: [Adventure] = [
        // Nature
        Adventure(
            title: "Golden Gate Sunrise",
            description: "Wake up early and catch the sunrise over the Golden Gate Bridge from Battery Spencer. Bring a thermos of coffee and enjoy the misty morning views.",
            category: .nature,
            effortLevel: .medium,
            locationName: "Battery Spencer",
            latitude: 37.8324,
            longitude: -122.4795
        ),
        Adventure(
            title: "Muir Woods Wander",
            description: "Lose yourself among ancient coastal redwoods on the easy loop trails. Listen for the creek and look up — way up.",
            category: .nature,
            effortLevel: .low,
            locationName: "Muir Woods",
            latitude: 37.8970,
            longitude: -122.5811
        ),
        Adventure(
            title: "Twin Peaks Summit",
            description: "Hike to the top of Twin Peaks for a panoramic 360° view of the entire city. Best on a clear day — or a dramatically foggy one.",
            category: .nature,
            effortLevel: .high,
            locationName: "Twin Peaks",
            latitude: 37.7544,
            longitude: -122.4477
        ),

        // Urban
        Adventure(
            title: "Alley Art Walk",
            description: "Explore the vibrant murals of Clarion Alley and Balmy Alley in the Mission District. Every visit reveals something new.",
            category: .urban,
            effortLevel: .low,
            locationName: "Clarion Alley",
            latitude: 37.7630,
            longitude: -122.4198
        ),
        Adventure(
            title: "Chinatown After Dark",
            description: "Wander through the oldest Chinatown in North America as the lanterns glow. Duck into a tea shop or find a late-night dim sum spot.",
            category: .urban,
            effortLevel: .low,
            locationName: "Chinatown",
            latitude: 37.7941,
            longitude: -122.4078
        ),
        Adventure(
            title: "Stairway Scavenger Hunt",
            description: "Discover the city's hidden mosaic staircases — 16th Avenue Tiled Steps and the Lincoln Park Steps. Climb them all.",
            category: .urban,
            effortLevel: .high,
            locationName: "16th Avenue Tiled Steps",
            latitude: 37.7560,
            longitude: -122.4738
        ),

        // Water
        Adventure(
            title: "Kayak McCovey Cove",
            description: "Rent a kayak and paddle around McCovey Cove near the ballpark. You might even catch a splash hit on game day.",
            category: .water,
            effortLevel: .medium,
            locationName: "McCovey Cove",
            latitude: 37.7786,
            longitude: -122.3893
        ),
        Adventure(
            title: "Baker Beach Bonfire",
            description: "Gather friends for a sunset bonfire on Baker Beach with the Golden Gate Bridge as your backdrop. Bring marshmallows.",
            category: .water,
            effortLevel: .low,
            locationName: "Baker Beach",
            latitude: 37.7936,
            longitude: -122.4835
        ),
        Adventure(
            title: "Aquatic Park Swim",
            description: "Join the brave souls who swim in the chilly waters of Aquatic Park. Wetsuits recommended — bragging rights guaranteed.",
            category: .water,
            effortLevel: .high,
            locationName: "Aquatic Park",
            latitude: 37.8070,
            longitude: -122.4232
        ),

        // Food
        Adventure(
            title: "Ferry Building Feast",
            description: "Graze your way through the Ferry Building Marketplace — artisan cheese, fresh oysters, craft coffee, and more.",
            category: .food,
            effortLevel: .low,
            locationName: "Ferry Building",
            latitude: 37.7956,
            longitude: -122.3935
        ),
        Adventure(
            title: "Mission Taqueria Crawl",
            description: "Sample burritos and tacos from three legendary Mission District taquerias. Bring your appetite and an open mind.",
            category: .food,
            effortLevel: .medium,
            locationName: "Mission District",
            latitude: 37.7599,
            longitude: -122.4148
        ),
        Adventure(
            title: "North Beach Espresso Trail",
            description: "Sip espresso at the historic Italian cafés of North Beach. Start at Caffè Trieste and work your way through literary history.",
            category: .food,
            effortLevel: .low,
            locationName: "North Beach",
            latitude: 37.8005,
            longitude: -122.4099
        ),

        // Cultural
        Adventure(
            title: "SFMOMA Slow Look",
            description: "Pick just one floor of SFMOMA and spend a full hour really looking. No phones, no rushing — just art.",
            category: .cultural,
            effortLevel: .low,
            locationName: "SFMOMA",
            latitude: 37.7857,
            longitude: -122.4011
        ),
        Adventure(
            title: "Jazz at the Fillmore",
            description: "Catch a live jazz show in the historic Fillmore District, the neighborhood that shaped West Coast jazz.",
            category: .cultural,
            effortLevel: .medium,
            locationName: "Fillmore District",
            latitude: 37.7841,
            longitude: -122.4325
        ),
        Adventure(
            title: "Alcatraz Night Tour",
            description: "Take the evening ferry to Alcatraz for the atmospheric night tour. Fewer crowds, better light, and real chills.",
            category: .cultural,
            effortLevel: .medium,
            locationName: "Alcatraz Island",
            latitude: 37.8267,
            longitude: -122.4233
        ),
    ]
}
