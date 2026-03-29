import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Dashboard", systemImage: "chart.pie.fill") {
                DashboardView()
            }

            Tab("Transactions", systemImage: "list.bullet.rectangle") {
                NavigationStack {
                    TransactionHistoryView()
                }
            }

            Tab("Categories", systemImage: "folder.fill") {
                NavigationStack {
                    CategoryManagementView()
                }
            }
        }
    }
}

#Preview(traits: .sampleData) {
    ContentView()
}
