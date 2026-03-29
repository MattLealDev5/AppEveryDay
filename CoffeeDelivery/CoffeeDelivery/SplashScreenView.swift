//
//  SplashScreenView.swift
//  CoffeeDelivery
//
//  Created by Matthew Leal on 3/15/26.
//

import SwiftUI

struct SplashScreenView: View {
    private enum Phase {
        case initial, expanding, complete, shrinking
    }

    var onFinished: () -> Void = {}

    @State private var phase: Phase = .initial
    @State private var backgroundOpacity: Double = 1.0

    // Derived from the SVG: icon spans x=0...43, full logo is 154pt wide
    private let iconWidth: CGFloat = 43
    private let logoWidth: CGFloat = 154
    private let logoHeight: CGFloat = 72

    // Circle grows from a 32pt dot to full-bleed
    private var circleSize: CGFloat {
        phase == .initial ? 32 : 955
    }

    // Mask reveals the logo from the leading edge
    private var maskWidth: CGFloat {
        switch phase {
        case .initial:              return 0
        case .expanding:            return iconWidth
        case .complete, .shrinking: return logoWidth
        }
    }

    // Offset that keeps the icon center aligned to screen center while text is hidden,
    // then returns to zero once the full centered logo is revealed
    private var logoOffsetX: CGFloat {
        switch phase {
        case .initial, .expanding:  return (logoWidth - iconWidth) / 2  // 55.5pt
        case .complete, .shrinking: return 0
        }
    }

    private var shrinkScale: CGFloat { phase == .shrinking ? 0.01 : 1.0 }
    private var shrinkOpacity: Double { phase == .shrinking ? 0.0  : 1.0 }

    var body: some View {
        ZStack {
            Color(red: 75 / 255, green: 41 / 255, blue: 149 / 255)
                .ignoresSafeArea()
                .opacity(backgroundOpacity)

            // Decorative circle: starts as a small dot, expands to fill the screen
            Circle()
                .fill(Color(red: 128 / 255, green: 71 / 255, blue: 248 / 255))
                .frame(width: circleSize, height: circleSize)

            // Logo: icon wipes in first, then text is revealed
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: logoWidth, height: logoHeight)
                .mask(alignment: .leading) {
                    Rectangle()
                        .frame(width: maskWidth)
                }
                .offset(x: logoOffsetX)
        }
        .scaleEffect(shrinkScale)
        .opacity(shrinkOpacity)
        .onAppear {
            // Phase 1 → 2: circle expands, icon appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeOut(duration: 0.7)) {
                    phase = .expanding
                }
            }
            // Phase 2 → 3: text slides in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    phase = .complete
                }
            }
            // Fade out the flat background before the shrink so it doesn't linger
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeOut(duration: 0.5)) {
                    backgroundOpacity = 0.0
                }
            }
            // Phase 3 → 4: shrink toward center
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeIn(duration: 0.4)) {
                    phase = .shrinking
                }
            }
            // Signal completion after shrink finishes + brief pause
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.7) {
                onFinished()
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
