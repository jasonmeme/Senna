import SwiftUI

struct AuthenticationView: View {
    @State private var isSignIn = true
    
    var body: some View {
        NavigationStack {
            VStack(spacing: Theme.spacing) {
                if isSignIn {
                    SignInView()
                } else {
                    SignUpView()
                }
                Button(isSignIn ? "Create an account" : "Already have an account?") {
                    withAnimation(Theme.animation) {
                        isSignIn.toggle()
                    }
                }
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
} 