import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        ZStack {
            if authManager.isAuthenticated {
                MainTabView()
                // if authManager.isProfileComplete {
                //     MainTabView()
                // } else {
                //     ProfileSetupView()
                // }
            } else {
                AuthenticationView()
            }
        }
    }
}