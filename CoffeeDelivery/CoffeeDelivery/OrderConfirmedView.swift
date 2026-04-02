//
//  OrderConfirmedView.swift
//  CoffeeDelivery
//

import SwiftUI

// MARK: - Delivery Illustration

private struct DeliveryIllustration: View {
    private let width: CGFloat  = 270
    private let height: CGFloat = 161

    var body: some View {
        // Each layer is positioned using the percentages from the Figma inset values:
        //   inset: [top% right% bottom% left%]  →  x = left%·W,  y = top%·H
        //   layer width  = (1 − left% − right%) · W
        //   layer height = (1 − top%  − bottom%) · H
        ZStack(alignment: .topLeading) {
            // Background  inset: 26%  5.19%  4.35%  2.39%
            Image("Background")
                .resizable()
                .scaledToFill()
                .frame(width: 249.5, height: 112.1)
                .clipped()
                .offset(x: 6.5, y: 41.9)

            // Scooter  inset: 33.39%  14.92%  4.77%  29.32%
            Image("Scooter")
                .resizable()
                .scaledToFit()
                .frame(width: 150.6, height: 99.6)
                .offset(x: 79.2, y: 53.8)

            // Person  inset: 4.32%  31.26%  21.05%  45.27%
            Image("Person")
                .resizable()
                .scaledToFit()
                .frame(width: 63.4, height: 120.1)
                .offset(x: 122.2, y: 7.0)
        }
        .frame(width: width, height: height)
    }
}

// MARK: - OrderConfirmedView

struct OrderConfirmedView: View {
    var onGoHome: () -> Void = {}

    var body: some View {
        ZStack {
            Color(red: 250/255, green: 250/255, blue: 250/255)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                DeliveryIllustration()

                Spacer().frame(height: 40)

                Text("Uhu! Pedido confirmado")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(red: 196/255, green: 127/255, blue: 23/255))
                    .multilineTextAlignment(.center)
                    .frame(width: 279)

                Spacer().frame(height: 12)

                Text("Agora é só aguardar que logo o café chegará até você!")
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 64/255, green: 57/255, blue: 55/255))
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .frame(width: 259)

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

                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Preview

#Preview {
    OrderConfirmedView()
}
