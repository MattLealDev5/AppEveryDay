import SwiftUI
import MapKit

struct ContentView: View {
    @State private var adventures = Adventure.sampleAdventures
    @State private var currentIndex = 0
    @State private var showFilters = false
    @State private var selectedCategories: Set<AdventureCategory> = Set(AdventureCategory.allCases)
    @State private var maxEffort: EffortLevel = .high
    @State private var mapPosition: MapCameraPosition = .automatic

    private var filteredAdventures: [Adventure] {
        adventures.filter { adventure in
            selectedCategories.contains(adventure.category) &&
            adventure.effortLevel <= maxEffort
        }
    }

    private var currentAdventure: Adventure? {
        guard !filteredAdventures.isEmpty else { return nil }
        let safeIndex = currentIndex % filteredAdventures.count
        return filteredAdventures[safeIndex]
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Map background
            Map(position: $mapPosition) {
                if let adventure = currentAdventure {
                    Marker(
                        adventure.title,
                        systemImage: adventure.category.icon,
                        coordinate: adventure.coordinate
                    )
                    .tint(markerColor(for: adventure.category))
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .ignoresSafeArea()

            // Gradient overlay for readability
            VStack(spacing: 0) {
                LinearGradient(
                    colors: [.black.opacity(0.4), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 120)

                Spacer()

                LinearGradient(
                    colors: [.clear, .black.opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 200)
            }
            .ignoresSafeArea()

            // Content overlay
            VStack(spacing: 0) {
                // Header
                header
                    .padding(.horizontal)
                    .padding(.top, 8)

                Spacer()

                // Adventure card
                if let adventure = currentAdventure {
                    AdventureCardView(adventure: adventure) {
                        markCurrentDone()
                    }
                    .padding(.horizontal)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                    .id(adventure.id)
                } else {
                    noAdventuresView
                        .padding(.horizontal)
                }

                // Next adventure button
                nextButton
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
            }
        }
        .sheet(isPresented: $showFilters) {
            FilterView(
                selectedCategories: $selectedCategories,
                maxEffort: $maxEffort
            )
            .presentationDetents([.medium, .large])
        }
        .onChange(of: currentIndex) {
            updateMapPosition()
        }
        .onChange(of: selectedCategories) {
            currentIndex = 0
            updateMapPosition()
        }
        .onChange(of: maxEffort) {
            currentIndex = 0
            updateMapPosition()
        }
        .onAppear {
            updateMapPosition()
        }
    }

    // MARK: - Subviews

    private var header: some View {
        HStack {
            Text("Micro Adventures")
                .font(.title)
                .fontWeight(.black)
                .foregroundStyle(.white)

            Spacer()

            Button {
                showFilters = true
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    .font(.title2)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.white)
            }
        }
    }

    private var nextButton: some View {
        Button {
            withAnimation(.spring(duration: 0.4, bounce: 0.2)) {
                advanceToNext()
            }
        } label: {
            Text("Next Adventure")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(.ultraThinMaterial)
                .background(Color.accentColor.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .disabled(filteredAdventures.isEmpty)
    }

    private var noAdventuresView: some View {
        VStack(spacing: 12) {
            Image(systemName: "binoculars.fill")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text("No adventures match your filters")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("Try adjusting your category or effort filters")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Actions

    private func advanceToNext() {
        guard !filteredAdventures.isEmpty else { return }
        currentIndex = (currentIndex + 1) % filteredAdventures.count
    }

    private func markCurrentDone() {
        guard let current = currentAdventure,
              let realIndex = adventures.firstIndex(where: { $0.id == current.id }) else { return }
        withAnimation {
            adventures[realIndex].isCompleted = true
        }
    }

    private func updateMapPosition() {
        if let adventure = currentAdventure {
            withAnimation(.easeInOut(duration: 0.5)) {
                mapPosition = .region(
                    MKCoordinateRegion(
                        center: adventure.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                )
            }
        }
    }

    private func markerColor(for category: AdventureCategory) -> Color {
        switch category {
        case .nature: return .green
        case .urban: return .purple
        case .food: return .orange
        case .creative: return .pink
        case .social: return .blue
        case .fitness: return .red
        }
    }
}

#Preview {
    ContentView()
}
