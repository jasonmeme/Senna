import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                MainTabView()
            } else {
                AuthenticationView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationManager())
} 