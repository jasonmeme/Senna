import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem {
                    Label("Feed", systemImage: "list.bullet")
                }
                .tag(0)
            
            CreateWorkoutView()
                .tabItem {
                    Label("Workout", systemImage: "plus.circle.fill")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
                .tag(2)
        }
        .tint(.accentColor)
    }
} 