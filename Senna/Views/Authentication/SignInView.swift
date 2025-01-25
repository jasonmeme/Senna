import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    
    var body: some View {
        VStack(spacing: Theme.spacing) {
            // Email field
            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 300)
            
            // Password field
            SecureField("Password", text: $password)
                .textContentType(.password)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 300)
            
            // Sign in button
            Button {
                Task {
                    do {
                        try await authManager.signInWithEmail(email: email, password: password)
                    } catch {
                        showAlert = true
                    }
                }
            } label: {
                if authManager.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Sign In")
                        .frame(maxWidth: 300)
                }
            }
            .primaryButtonStyle()
            .disabled(email.isEmpty || password.isEmpty || authManager.isLoading)
            
            // Social sign in options
            HStack(spacing: Theme.spacing) {
                Button {
                    // Apple sign in
                } label: {
                    Image(systemName: "apple.logo")
                        .font(.title2)
                }
                .buttonStyle(.bordered)
                
                Button {
                    // Google sign in
                } label: {
                    Image(systemName: "g.circle.fill")
                        .font(.title2)
                }
                .buttonStyle(.bordered)
            }
            .padding(.top)
        }
        .alert("Sign In Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(authManager.error?.localizedDescription ?? "Please try again")
        }
    }
} 