import SwiftUI

struct AuthenticationView: View {
    @State private var isSignIn = true
    
    var body: some View {
        NavigationStack {
            VStack(spacing: Theme.spacing) {
                // Logo
                Image(systemName: "figure.run.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Theme.primaryColor)
                
                Text("Senna")
                    .font(.largeTitle.bold())
                
                // Auth form
                if isSignIn {
                    SignInView()
                } else {
                    SignUpView()
                }
                
                // Toggle button
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