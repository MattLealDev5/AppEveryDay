//
//  CoffeeDeliveryApp.swift
//  CoffeeDelivery
//
//  Created by Matthew Leal on 3/15/26.
//

import SwiftUI

@main
struct CoffeeDeliveryApp: App {
    @State private var showSplash = true
    @State private var splashFinished = false
    @State private var cart = CartViewModel()
    @State private var navigationPath = NavigationPath()

    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack(path: $navigationPath) {
                    CatalogueView(splashFinished: splashFinished)
                        .navigationBarHidden(true)
                        .navigationDestination(for: Coffee.self) { coffee in
                            ProductView(coffee: coffee)
                                .navigationBarHidden(true)
                        }
                }

                if showSplash {
                    SplashScreenView {
                        showSplash = false
                        splashFinished = true
                    }
                }
            }
            .environment(cart)
            .fullScreenCover(isPresented: Bindable(cart).showOrderConfirmed) {
                OrderConfirmedView {
                    cart.showOrderConfirmed = false
                    navigationPath = NavigationPath()
                }
            }
        }
    }
}
