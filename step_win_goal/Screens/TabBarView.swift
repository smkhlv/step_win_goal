import SwiftUI

struct TabBarView: View {
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            NavigationView {
                ActivitySummaryView()
            }
            .tabItem {
                Label("Главная", image: selectedIndex == 0 ? "home_selected" : "home")
            }
            .tag(0)
            
            NavigationView {
                ScrollView {
                    HistoryView()
                }
            }
            .tabItem {
                Label("История активности", image: selectedIndex == 1 ? "activity_selected" : "activity")
            }
            .tag(1)
            
            NavigationView {
                ScrollView {
                    AchievementView()
                }
            }
            .tabItem {
                Label(String(localized: "Achievements"), image: selectedIndex == 2 ? "medal_selected" : "medal")
            }
            .tag(2)
        }
    }
}
