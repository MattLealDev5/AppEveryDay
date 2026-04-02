//
//  CatalogueView.swift
//  CoffeeDelivery
//
//  Created by Matthew Leal on 3/15/26.
//

import SwiftUI

// MARK: - Palette

private extension Color {
    static let darkBg      = Color(red: 39/255,  green: 34/255,  blue: 33/255)
    static let darkField   = Color(red: 64/255,  green: 57/255,  blue: 55/255)
    static let brand       = Color(red: 128/255, green: 71/255,  blue: 248/255)
    static let brandDark   = Color(red: 75/255,  green: 41/255,  blue: 149/255)
    static let brandLight  = Color(red: 235/255, green: 229/255, blue: 249/255)
    static let brandYellow = Color(red: 196/255, green: 127/255, blue: 23/255)
    static let cardBg      = Color(red: 243/255, green: 242/255, blue: 242/255)
    static let cardBorder  = Color(red: 237/255, green: 237/255, blue: 237/255)
    static let textPrimary = Color(red: 64/255,  green: 57/255,  blue: 55/255)
    static let textGray    = Color(red: 141/255, green: 134/255, blue: 134/255)
    static let textSection = Color(red: 87/255,  green: 79/255,  blue: 77/255)
    static let appBg       = Color(red: 250/255, green: 250/255, blue: 250/255)
}

// MARK: - Card shape  TL:6  TR:36  BL:36  BR:6

private let cardShape = UnevenRoundedRectangle(
    topLeadingRadius: 6, bottomLeadingRadius: 36,
    bottomTrailingRadius: 6, topTrailingRadius: 36
)

// MARK: - Coffee image view

private struct CoffeeImage: View {
    let imageName: String
    var size: CGFloat = 96

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
}

// MARK: - Shared sub-views

private struct FilterPill: View {
    let label: String
    let isActive: Bool
    var body: some View {
        Text(label.uppercased())
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(.brandDark)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isActive ? Color.brandLight : Color.clear)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.brand, lineWidth: 1))
    }
}

// MARK: - Featured card (horizontal carousel)

private struct FeaturedCard: View {
    let coffee: Coffee
    var isActive: Bool = false

    private let containerWidth: CGFloat = 208

    private var cardWidth: CGFloat  { isActive ? 208 : 166 }
    private var imgSize: CGFloat    { isActive ? 120 : 96  }
    private var titleSize: CGFloat  { isActive ? 20  : 16  }
    private var descSize: CGFloat   { isActive ? 12  : 10  }
    private var priceSize: CGFloat  { isActive ? 24  : 20  }
    private var hPad: CGFloat       { isActive ? 16  : 12  }
    private var vGap: CGFloat       { isActive ? 14  : 12  }

    /// How far the image center sits above the top edge of the card.
    private var imageOverhang: CGFloat { isActive ? 60 : 48 }

    /// Top padding inside the card to clear the portion of image still inside.
    private var cardTopInset: CGFloat { imgSize - imageOverhang + 12 }

    var body: some View {
        VStack(spacing: 0) {
            // Coffee image — positioned above the card
            CoffeeImage(imageName: coffee.imageName, size: imgSize)
                .zIndex(1)
                // Pull the image down so its bottom half overlaps the card top
                .padding(.bottom, -imageOverhang)

            // Card body
            VStack(spacing: vGap) {
                Text(coffee.category.rawValue.uppercased())
                    .font(.system(size: isActive ? 10 : 8, weight: .bold))
                    .foregroundColor(.brandDark)
                    .padding(.horizontal, isActive ? 8 : 6)
                    .padding(.vertical, isActive ? 4 : 3)
                    .background(Color.brandLight)
                    .clipShape(Capsule())

                VStack(spacing: isActive ? 4 : 3) {
                    Text(coffee.name)
                        .font(.system(size: titleSize, weight: .bold))
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)
                    Text(coffee.description)
                        .font(.system(size: descSize))
                        .foregroundColor(.textGray)
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                }

                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    Text("R$ ").font(.system(size: 14)).foregroundColor(.brandYellow)
                    Text(coffee.price).font(.system(size: priceSize, weight: .bold)).foregroundColor(.brandYellow)
                }
            }
            .padding(.horizontal, hPad)
            .padding(.top, cardTopInset)
            .padding(.bottom, isActive ? 20 : 16)
            .frame(width: cardWidth)
            .background(Color.cardBg)
            .clipShape(cardShape)
            .overlay(cardShape.stroke(Color.cardBorder, lineWidth: isActive ? 1 : 0.8))
            .shadow(color: .black.opacity(0.05), radius: isActive ? 4 : 3, x: 0, y: isActive ? 2 : 1.6)
        }
        // Fixed container width so the scroll target is consistent regardless of active state
        .frame(width: containerWidth)
        .animation(.snappy(duration: 0.35), value: isActive)
    }
}

// MARK: - List card (vertical catalogue)

private struct CoffeeListCard: View {
    let coffee: Coffee
    var body: some View {
        HStack(spacing: 0) {
            CoffeeImage(imageName: coffee.imageName, size: 96)
                .padding(.leading, 7)

            VStack(alignment: .leading, spacing: 4) {
                Text(coffee.name)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.textPrimary)
                Text(coffee.description)
                    .font(.system(size: 12))
                    .foregroundColor(.textGray)
                    .lineLimit(2)
                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    Text("R$ ").font(.system(size: 14)).foregroundColor(.brandYellow)
                    Text(coffee.price).font(.system(size: 20, weight: .bold)).foregroundColor(.brandYellow)
                }
                .padding(.top, 2)
            }
            .padding(.leading, 12)
            .padding(.trailing, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 120)
        .background(Color.cardBg)
        .clipShape(cardShape)
        .overlay(cardShape.stroke(Color.cardBorder, lineWidth: 1))
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

// MARK: - CatalogueView

struct CatalogueView: View {
    @Environment(CartViewModel.self) private var cart

    var splashFinished: Bool = true

    @State private var searchText = ""
    @State private var activeFilters: Set<CoffeeCategory> = []
    @State private var activeCardID: Coffee.ID?
    @State private var introPhase: IntroPhase

    init(splashFinished: Bool = true) {
        self.splashFinished = splashFinished
        _introPhase = State(initialValue: splashFinished ? .full : .blank)
    }

    private enum IntroPhase { case blank, header, full }

    // Drives the three animation properties
    private var headerYOffset: CGFloat   { introPhase == .blank ? -350 : 0   }
    private var carouselXOffset: CGFloat { introPhase == .full  ?    0 : 500 }
    private var contentOpacity: Double   { introPhase == .full  ?    1 : 0   }

    private var visibleCategories: [CoffeeCategory] {
        CoffeeCategory.allCases.filter { category in
            (activeFilters.isEmpty || activeFilters.contains(category)) &&
            !coffees(for: category).isEmpty
        }
    }

    private func coffees(for category: CoffeeCategory) -> [Coffee] {
        Coffee.allCoffees.filter {
            $0.category == category &&
            (searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText))
        }
    }

    var body: some View {
        ZStack {
            // White base — visible during the blank phase
            Color.appBg.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // Starts 350pt above screen; slides down into position
                    headerSection
                        .offset(y: headerYOffset)

                    // Starts off-screen to the right; slides left once header is done
                    featuredCarousel
                        .padding(.top, -70)
                        .offset(x: carouselXOffset)
                        .opacity(contentOpacity)

                    listHeader
                        .padding(.top, 16)
                        .opacity(contentOpacity)

                    coffeeList
                        .opacity(contentOpacity)
                        .padding(.bottom, 40)
                }
            }
            // Allow content to render outside the scroll frame so the header
            // is visible as it animates down from above the scroll view's bounds
            .scrollClipDisabled()
            .background(Color.appBg)
        }
        .clipped()
        .sheet(isPresented: Bindable(cart).showCart) {
            CartView()
        }
        .onChange(of: splashFinished) { _, finished in
            guard finished else { return }
            // Phase 1 → 2: dark header slides down from above
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.easeOut(duration: 0.65)) {
                    introPhase = .header
                }
            }
            // Phase 2 → 3: carousel slides in from the right, list fades in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    introPhase = .full
                }
            }
        }
    }

    // MARK: Dark header (navbar + title + search)

    private var headerSection: some View {
        VStack(spacing: 0) {
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 16))
                        .foregroundColor(.brand)
                    Text("Porto Alegre, RS")
                        .font(.system(size: 14))
                        .foregroundColor(.appBg)
                }
                Spacer()
                Button { cart.showCart = true } label: {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "cart")
                            .font(.system(size: 18))
                            .foregroundColor(.brandYellow)
                            .padding(8)
                            .background(Color.brandYellow.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 6))

                        if cart.totalCount > 0 {
                            Circle()
                                .fill(Color.brandYellow)
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Text("\(cart.totalCount)")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.white)
                                )
                                .offset(x: 8, y: -8)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 20)

            VStack(alignment: .leading, spacing: 16) {
                Text("Encontre o café perfeito\npara qualquer hora do dia")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .lineSpacing(2)

                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 14))
                        .foregroundColor(.textGray)
                    TextField(
                        "",
                        text: $searchText,
                        prompt: Text("Pesquisar").foregroundColor(.textGray)
                    )
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .tint(.brand)
                }
                .padding(12)
                .background(Color.darkField)
                .cornerRadius(4)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 90) // extra space so carousel overlaps a dark background
        }
        .background {
            Color.darkBg.ignoresSafeArea(edges: .top)
        }
    }

    // MARK: Featured horizontal carousel with snap

    private var featuredCarousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .top, spacing: 16) {
                ForEach(Coffee.featured) { coffee in
                    NavigationLink(value: coffee) {
                        FeaturedCard(
                            coffee: coffee,
                            isActive: coffee.id == activeCardID
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .scrollTargetLayout()
            .padding(.bottom, 20)
        }
        .safeAreaPadding(.horizontal, 76)
        .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
        .scrollPosition(id: $activeCardID, anchor: .center)
        .scrollClipDisabled()
        .onAppear {
            if activeCardID == nil {
                activeCardID = Coffee.featured.first?.id
            }
        }
    }

    // MARK: List header ("Nossos cafés" + filter pills)

    private var listHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Nossos cafés")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.textSection)

            HStack(spacing: 8) {
                ForEach(CoffeeCategory.allCases) { category in
                    Button {
                        if activeFilters.contains(category) {
                            activeFilters.remove(category)
                        } else {
                            activeFilters.insert(category)
                        }
                    } label: {
                        FilterPill(label: category.rawValue, isActive: activeFilters.contains(category))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 32)
        .padding(.vertical, 16)
        .background(Color.appBg)
    }

    // MARK: Coffee list grouped by category

    private var coffeeList: some View {
        VStack(spacing: 48) {
            ForEach(visibleCategories) { category in
                VStack(alignment: .leading, spacing: 32) {
                    Text(category.rawValue)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.textGray)

                    VStack(spacing: 32) {
                        ForEach(coffees(for: category)) { coffee in
                            NavigationLink(value: coffee) {
                                CoffeeListCard(coffee: coffee)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 32)
            }
        }
    }
}

#Preview {
    NavigationStack {
        CatalogueView()
            .navigationBarHidden(true)
    }
    .environment(CartViewModel())
}
