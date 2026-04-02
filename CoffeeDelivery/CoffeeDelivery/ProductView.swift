//
//  ProductView.swift
//  CoffeeDelivery
//
//  Created by Matthew Leal on 3/15/26.
//

import SwiftUI

// MARK: - Palette

private extension Color {
    static let darkBg      = Color(red: 39/255,  green: 34/255,  blue: 33/255)
    static let tagBg       = Color(red: 64/255,  green: 57/255,  blue: 55/255)
    static let brand       = Color(red: 128/255, green: 71/255,  blue: 248/255)
    static let brandDark   = Color(red: 75/255,  green: 41/255,  blue: 149/255)
    static let brandYellow = Color(red: 219/255, green: 172/255, blue: 44/255)
    static let footerBg    = Color(red: 250/255, green: 250/255, blue: 250/255)
    static let sizeBtn     = Color(red: 237/255, green: 237/255, blue: 237/255)
    static let textLight   = Color(red: 215/255, green: 213/255, blue: 213/255)
    static let textMuted   = Color(red: 141/255, green: 134/255, blue: 134/255)
    static let textBody    = Color(red: 87/255,  green: 79/255,  blue: 77/255)
}

// MARK: - ProductView

struct ProductView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(CartViewModel.self) private var cart

    let coffee: Coffee

    @State private var selectedSize: CoffeeSize = .large
    @State private var quantity: Int = 1

    var body: some View {
        VStack(spacing: 0) {
            // Dark upper section: navbar + info + coffee image
            ZStack(alignment: .top) {
                // Coffee image + smoke — floats to the bottom of the dark area
                VStack {
                    Spacer(minLength: 0)
                    ZStack(alignment: .bottom) {
                        Image("coffee_generic")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 48)
                            .shadow(color: .black.opacity(0.16), radius: 16, x: 0, y: 2)

                        Image("Smoke")
                            .resizable()
                            .frame(width: 64, height: 137)
                            .scaleEffect(y: -1)
                            .offset(y: -198)
                    }
                    .padding(.bottom, 16)
                }

                // Navbar + info — anchored to top
                VStack(alignment: .leading, spacing: 0) {
                    navbar
                    infoSection
                        .padding(.horizontal, 32)
                        .padding(.top, 32)
                }
            }
            .frame(maxHeight: .infinity)
            .background {
                Color.darkBg.ignoresSafeArea(edges: .top)
            }

            // Light footer
            footer
                .frame(height: 222)
                .background(Color.footerBg)
        }
        .sheet(isPresented: Bindable(cart).showCart) {
            CartView()
        }
    }

    // MARK: Navbar

    private var navbar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
            }
            .buttonStyle(.plain)

            Spacer()

            Button { cart.showCart = true } label: {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "cart")
                        .font(.system(size: 20))
                        .foregroundColor(.brand)
                        .padding(8)
                        .background(Color.brand.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 6))

                    if cart.totalCount > 0 {
                        Circle()
                            .fill(Color.brand)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Text("\(cart.totalCount)")
                                    .font(.system(size: 12))
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
    }

    // MARK: Info section

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .lastTextBaseline) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(coffee.category.rawValue.uppercased())
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.tagBg)
                        .clipShape(Capsule())

                    Text(coffee.name)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }

                Spacer()

                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    Text("R$ ")
                        .font(.system(size: 14))
                        .foregroundColor(.brandYellow)
                    Text(coffee.price)
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.brandYellow)
                }
            }

            Text(coffee.description)
                .font(.system(size: 16))
                .foregroundColor(.textLight)
                .lineSpacing(4)
        }
    }

    // MARK: Footer

    private var footer: some View {
        VStack(spacing: 8) {
            Text("Selecione o tamanho:")
                .font(.system(size: 14))
                .foregroundColor(.textMuted)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 8) {
                ForEach(CoffeeSize.allCases, id: \.self) { size in
                    Button {
                        selectedSize = size
                    } label: {
                        let active = selectedSize == size
                        Text(size.rawValue)
                            .font(.system(size: 14, weight: active ? .bold : .regular))
                            .foregroundColor(active ? .brand : .textBody)
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .background(Color.sizeBtn)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(active ? Color.brand : Color.clear, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    .animation(.easeInOut(duration: 0.15), value: selectedSize)
                }
            }

            HStack(spacing: 16) {
                // Quantity counter
                HStack(spacing: 0) {
                    Button {
                        if quantity > 1 { quantity -= 1 }
                    } label: {
                        Image(systemName: "minus")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.brand)
                            .frame(width: 36, height: 36)
                    }
                    .buttonStyle(.plain)

                    Text("\(quantity)")
                        .font(.system(size: 16))
                        .foregroundColor(.darkBg)
                        .frame(width: 24)

                    Button {
                        quantity += 1
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.brand)
                            .frame(width: 36, height: 36)
                    }
                    .buttonStyle(.plain)
                }
                .background(Color.sizeBtn)
                .clipShape(RoundedRectangle(cornerRadius: 6))

                // Add button
                Button {
                    cart.add(coffee: coffee, size: selectedSize, quantity: quantity)
                    quantity = 1
                } label: {
                    Text("ADICIONAR")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 46)
                        .background(Color.brandDark)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 20)
    }
}

// MARK: - Preview

#Preview {
    ProductView(coffee: Coffee.allCoffees.first { $0.name == "Irlandês" }!)
        .environment(CartViewModel())
}
