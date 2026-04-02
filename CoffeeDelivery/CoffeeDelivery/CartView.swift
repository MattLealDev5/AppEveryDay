//
//  CartView.swift
//  CoffeeDelivery
//

import SwiftUI

// MARK: - Palette

private extension Color {
    static let appBg         = Color(red: 250/255, green: 250/255, blue: 250/255)
    static let rowBorder     = Color(red: 237/255, green: 237/255, blue: 237/255)
    static let counterBorder = Color(red: 230/255, green: 229/255, blue: 229/255)
    static let deleteBg      = Color(red: 237/255, green: 237/255, blue: 237/255)
    static let swipeBg       = Color(red: 242/255, green: 223/255, blue: 216/255)
    static let swipeRed      = Color(red: 196/255, green: 65/255,  blue: 23/255)
    static let textPrimary   = Color(red: 39/255,  green: 34/255,  blue: 33/255)
    static let textMuted     = Color(red: 141/255, green: 134/255, blue: 134/255)
    static let textDark      = Color(red: 64/255,  green: 57/255,  blue: 55/255)
    static let brandYellow   = Color(red: 196/255, green: 127/255, blue: 23/255)
    static let brandPurple   = Color(red: 128/255, green: 71/255,  blue: 248/255)
}

// MARK: - CartItemRow

private struct CartItemRow: View {
    @Binding var item: CartItem
    let onDelete: () -> Void

    private let rowHeight: CGFloat = 117
    private let deleteThreshold: CGFloat = 80

    @State private var offset: CGFloat = 0

    var body: some View {
        ZStack(alignment: .leading) {
            // Swipe-to-delete background (always behind the card)
            Color.swipeBg
                .overlay(alignment: .leading) {
                    Image(systemName: "trash")
                        .font(.system(size: 18))
                        .foregroundColor(.swipeRed)
                        .padding(.leading, 32)
                }

            // Card row
            HStack(spacing: 20) {
                Image(item.coffee.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.coffee.name)
                                .font(.system(size: 16))
                                .foregroundColor(.textPrimary)
                            Text(item.size.rawValue)
                                .font(.system(size: 14))
                                .foregroundColor(.textMuted)
                        }
                        Spacer()
                        Text("R$ \(item.coffee.price)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.textPrimary)
                    }

                    HStack(spacing: 8) {
                        // Quantity counter
                        HStack(spacing: 0) {
                            Button {
                                if item.quantity > 1 { item.quantity -= 1 }
                            } label: {
                                Image(systemName: "minus")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.brandPurple)
                                    .frame(width: 36, height: 36)
                            }
                            .buttonStyle(.plain)

                            Text("\(item.quantity)")
                                .font(.system(size: 16))
                                .foregroundColor(.textPrimary)
                                .frame(width: 20)

                            Button {
                                item.quantity += 1
                            } label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.brandPurple)
                                    .frame(width: 36, height: 36)
                            }
                            .buttonStyle(.plain)
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.counterBorder, lineWidth: 1)
                        }

                        // Inline delete button
                        Button(action: onDelete) {
                            Image(systemName: "trash")
                                .font(.system(size: 14))
                                .foregroundColor(.brandPurple)
                                .frame(width: 36, height: 36)
                                .background(Color.deleteBg)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 32)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: rowHeight)
            .background(Color.appBg)
            .offset(x: offset)
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onChanged { value in
                        let x = value.translation.width
                        if x > 0 { offset = x }
                    }
                    .onEnded { value in
                        if value.translation.width > deleteThreshold {
                            withAnimation(.easeOut(duration: 0.2)) {
                                offset = 500
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                onDelete()
                            }
                        } else {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                offset = 0
                            }
                        }
                    }
            )
        }
        .frame(height: rowHeight)
        .clipped()
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.rowBorder)
                .frame(height: 1)
        }
    }
}

// MARK: - CartView

struct CartView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(CartViewModel.self) private var cart

    var body: some View {
        @Bindable var cart = cart
        VStack(spacing: 0) {
            navbar

            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach($cart.items) { $item in
                        CartItemRow(item: $item) {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                cart.remove(id: item.id)
                            }
                        }
                    }
                }
            }
            .background(Color.appBg)

            orderFooter
        }
        .background(Color.appBg)
        .navigationBarHidden(true)
    }

    // MARK: Navbar

    private var navbar: some View {
        ZStack {
            Text("Carrinho")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.textDark)

            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18))
                        .foregroundColor(.textDark)
                }
                .buttonStyle(.plain)
                Spacer()
            }
        }
        .padding(.horizontal, 32)
        .frame(height: 56)
        .background(Color.appBg)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.rowBorder)
                .frame(height: 1)
        }
    }

    // MARK: Order footer

    private var orderFooter: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Valor total")
                    .font(.system(size: 16))
                    .foregroundColor(.textDark)
                Spacer()
                Text("R$ \(cart.formattedTotal)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.textDark)
            }

            Button {
                cart.confirmOrder()
            } label: {
                Text("CONFIRMAR PEDIDO")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .background(cart.items.isEmpty ? Color.gray : Color.brandYellow)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .buttonStyle(.plain)
            .disabled(cart.items.isEmpty)
        }
        .padding(.horizontal, 32)
        .padding(.top, 28)
        .padding(.bottom, 40)
        .background(Color.white)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: -2)
    }
}

// MARK: - Preview

#Preview {
    CartView()
        .environment(CartViewModel())
}
