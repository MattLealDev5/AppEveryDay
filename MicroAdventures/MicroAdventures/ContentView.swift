//
//  ContentView.swift
//  MicroAdventures
//
//  Created by Matthew Leal on 3/7/26.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @State private var adventures = Adventure.sampleAdventures
    @State private var currentIndex = 0
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var selectedCategories: Set<Category> = Set(Category.allCases)
    @State private var selectedEffortLevels: Set<EffortLevel> = Set(EffortLevel.allCases)

    private var filteredAdventures: [Adventure] {
        adventures.filter { adventure in
            selectedCategories.contains(adventure.category)
                && selectedEffortLevels.contains(adventure.effortLevel)
        }
    }

    private var allCategoriesSelected: Bool {
        selectedCategories.count == Category.allCases.count
    }

    private var allEffortLevelsSelected: Bool {
        selectedEffortLevels.count == EffortLevel.allCases.count
    }

    var body: some View {
        NavigationStack {
            Map(position: $cameraPosition) {
                if let adventure = filteredAdventures[safe: currentIndex] {
                    Marker(adventure.title, coordinate: adventure.coordinate)
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .overlay(alignment: .bottom) {
                if let adventure = bindingForCurrentAdventure() {
                    VStack(spacing: 12) {
                        AdventureCardView(adventure: adventure)

                        Button {
                            nextAdventure()
                        } label: {
                            Label("Next Adventure", systemImage: "arrow.forward")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                        }
                        .buttonStyle(.borderedProminent)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding()
                } else {
                    Text("No adventures match your filters.")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                        .padding()
                }
            }
            .navigationTitle("Micro Adventures")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Section("Categories") {
                            Button {
                                if allCategoriesSelected {
                                    selectedCategories.removeAll()
                                } else {
                                    selectedCategories = Set(Category.allCases)
                                }
                                resetIndex()
                            } label: {
                                Label(
                                    allCategoriesSelected ? "Deselect All" : "Select All",
                                    systemImage: allCategoriesSelected ? "xmark.circle" : "checkmark.circle"
                                )
                            }

                            ForEach(Category.allCases) { category in
                                Button {
                                    toggleCategory(category)
                                } label: {
                                    Label {
                                        Text(category.rawValue)
                                    } icon: {
                                        Image(systemName: selectedCategories.contains(category)
                                              ? "checkmark.square.fill"
                                              : "square")
                                    }
                                }
                            }
                        }

                        Section("Effort Level") {
                            Button {
                                if allEffortLevelsSelected {
                                    selectedEffortLevels.removeAll()
                                } else {
                                    selectedEffortLevels = Set(EffortLevel.allCases)
                                }
                                resetIndex()
                            } label: {
                                Label(
                                    allEffortLevelsSelected ? "Deselect All" : "Select All",
                                    systemImage: allEffortLevelsSelected ? "xmark.circle" : "checkmark.circle"
                                )
                            }

                            ForEach(EffortLevel.allCases) { level in
                                Button {
                                    toggleEffortLevel(level)
                                } label: {
                                    Label {
                                        Text(level.rawValue)
                                    } icon: {
                                        Image(systemName: selectedEffortLevels.contains(level)
                                              ? "checkmark.square.fill"
                                              : "square")
                                    }
                                }
                            }
                        }
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .onAppear {
                updateCamera()
            }
        }
    }

    private func bindingForCurrentAdventure() -> Binding<Adventure>? {
        guard let adventure = filteredAdventures[safe: currentIndex],
              let sourceIndex = adventures.firstIndex(where: { $0.id == adventure.id })
        else {
            return nil
        }
        return $adventures[sourceIndex]
    }

    private func nextAdventure() {
        guard !filteredAdventures.isEmpty else { return }
        currentIndex = (currentIndex + 1) % filteredAdventures.count
        updateCamera()
    }

    private func resetIndex() {
        currentIndex = 0
        updateCamera()
    }

    private func updateCamera() {
        guard let adventure = filteredAdventures[safe: currentIndex] else { return }
        withAnimation {
            cameraPosition = .camera(
                MapCamera(
                    centerCoordinate: adventure.coordinate,
                    distance: 50000
                )
            )
        }
    }

    private func toggleCategory(_ category: Category) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
        resetIndex()
    }

    private func toggleEffortLevel(_ level: EffortLevel) {
        if selectedEffortLevels.contains(level) {
            selectedEffortLevels.remove(level)
        } else {
            selectedEffortLevels.insert(level)
        }
        resetIndex()
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

struct AdventureCardView: View {
    @Binding var adventure: Adventure

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                PillView(
                    text: adventure.category.rawValue,
                    icon: adventure.category.icon,
                    color: adventure.category.color
                )
                PillView(
                    text: adventure.effortLevel.rawValue,
                    icon: adventure.effortLevel.icon,
                    color: adventure.effortLevel.color
                )
                Spacer()
            }

            Text(adventure.title)
                .font(.title2)
                .fontWeight(.bold)

            Text(adventure.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack {
                Spacer()
                CompletionButton(isCompleted: $adventure.isCompleted)
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct PillView: View {
    let text: String
    let icon: String
    let color: Color

    var body: some View {
        Label(text, systemImage: icon)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color.opacity(0.15), in: Capsule())
            .foregroundStyle(color)
    }
}

struct CompletionButton: View {
    @Binding var isCompleted: Bool

    var body: some View {
        Button {
            isCompleted.toggle()
        } label: {
            Label(
                isCompleted ? "Completed" : "Mark Complete",
                systemImage: isCompleted ? "checkmark.circle.fill" : "circle"
            )
            .font(.subheadline)
            .fontWeight(.medium)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                isCompleted ? Color.green.opacity(0.15) : Color.secondary.opacity(0.1),
                in: Capsule()
            )
            .foregroundStyle(isCompleted ? .green : .primary)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
}
