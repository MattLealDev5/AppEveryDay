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

    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack {
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
        }
    }
}
