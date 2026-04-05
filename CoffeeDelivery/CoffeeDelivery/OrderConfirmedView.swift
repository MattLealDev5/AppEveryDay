//
//  OrderConfirmedView.swift
//  CoffeeDelivery
//

import SwiftUI

// MARK: - Animation phase

private enum AnimPhase {
    case blank      // 1: everything hidden, rider off-screen left
    case riderIn    // 2: scooter + person slid to center
    case contentIn  // 2b: background + text faded in
    case buttonIn   // 3: button slid up from bottom
}

// MARK: - Delivery Illustration

private struct DeliveryIllustration: View {
    /// Drives scooter+person sliding from left (false) to center (true)
    let riderIn: Bool
    /// Drives the background image opacity
    let backgroundOpacity: Double

    private let width:  CGFloat = 270
    private let height: CGFloat = 161

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Background  — fades in after rider arrives
            // inset: top 26%  right 5.19%  bottom 4.35%  left 2.39%
            Image("Background")
                .resizable()
                .scaledToFill()
                .frame(width: 249.5, height: 112.1)
                .clipped()
                .offset(x: 6.5, y: 41.9)
                .opacity(backgroundOpacity)

            // Scooter — slides in with the rider
            // inset: top 33.39%  right 14.92%  bottom 4.77%  left 29.32%
            Image("Scooter")
                .resizable()
                .scaledToFit()
                .frame(width: 150.6, height: 99.6)
                .offset(x: 79.2, y: 53.8)

            // Person — slides in with the rider
            // inset: top 4.32%  right 31.26%  bottom 21.05%  left 45.27%
            Image("Person")
                .resizable()
                .scaledToFit()
                .frame(width: 63.4, height: 120.1)
                .offset(x: 122.2, y: 7.0)
        }
        .frame(width: width, height: height)
        // Whole illustration shifts in from the left as a unit
        .offset(x: riderIn ? 0 : -400)
    }
}

// MARK: - OrderConfirmedView

struct OrderConfirmedView: View {
    var onGoHome: () -> Void = {}

    @State private var phase: AnimPhase = .blank

    // Derived animation states
    private var riderIn:        Bool    { phase != .blank }
    private var bgOpacity:      Double  { phase == .contentIn || phase == .buttonIn ? 1 : 0 }
    private var contentOpacity: Double  { phase == .contentIn || phase == .buttonIn ? 1 : 0 }
    private var buttonOffset:   CGFloat { phase == .buttonIn ? 0 : 120 }
    private var buttonOpacity:  Double  { phase == .buttonIn ? 1 : 0 }

    var body: some View {
        ZStack {
            Color(red: 250/255, green: 250/255, blue: 250/255)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                DeliveryIllustration(riderIn: riderIn, backgroundOpacity: bgOpacity)

                Spacer().frame(height: 40)

                Text("Uhu! Pedido confirmado")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(red: 196/255, green: 127/255, blue: 23/255))
                    .multilineTextAlignment(.center)
                    .frame(width: 279)
                    .opacity(contentOpacity)

                Spacer().frame(height: 12)

                Text("Agora é só aguardar que logo o café chegará até você!")
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 64/255, green: 57/255, blue: 55/255))
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .frame(width: 259)
                    .opacity(contentOpacity)

                Spacer().frame(height: 76)

                Button {
                    onGoHome()
                } label: {
                    Text("IR PARA A HOME")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 247, height: 46)
                        .background(Color(red: 75/255, green: 41/255, blue: 149/255))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .buttonStyle(.plain)
                .offset(y: buttonOffset)
                .opacity(buttonOpacity)

                Spacer()
            }
            // Allow the rider to render while it slides in from off the left edge
            .clipped(antialiased: false)
        }
        .navigationBarHidden(true)
        .onAppear { animate() }
    }

    private func animate() {
        // Step 1 — short pause, then scooter + person slide in from the left
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.78)) {
                phase = .riderIn
            }
        }

        // Step 2 — after rider arrives, background + text fade in
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.easeInOut(duration: 0.6)) {
                phase = .contentIn
            }
        }

        // Step 3 — button slides up from the bottom
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            withAnimation(.spring(response: 0.65, dampingFraction: 0.75)) {
                phase = .buttonIn
            }
        }
    }
}

// MARK: - Preview

#Preview {
    OrderConfirmedView()
}
