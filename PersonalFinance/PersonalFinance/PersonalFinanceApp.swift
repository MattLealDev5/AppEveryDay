import SwiftUI
import SwiftData

@main
struct PersonalFinanceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Seed default categories on first launch
                }
        }
        .modelContainer(for: [Category.self, Transaction.self]) { result in
            if case .success(let container) = result {
                SampleData.seedIfNeeded(context: container.mainContext)
            }
        }
    }
}
