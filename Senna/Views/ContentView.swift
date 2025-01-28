import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        ZStack {
            if authManager.isInitializing {
                LoadingView()
            } else if authManager.isAuthenticated {
                if authManager.isProfileComplete {
                    MainTabView()
                } else {
                    ProfileSetupView()
                }
            } else {
                AuthenticationView()
            }
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading...")
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationManager())
} 