import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var isEmailFocused = false
    @State private var isPasswordFocused = false
    
    var body: some View {
        VStack(spacing: Theme.spacing * 1.5) {
            // Logo and Welcome Text
            VStack(spacing: 8) {
                Image("AppIcon") // Make sure to add your app icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(20)
                
                Text("Sign in to continue")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, Theme.spacing)
            
            // Email field
            VStack(alignment: .leading, spacing: 8) {
                Text("Email")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextField("", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textFieldStyle()
            }
            
            // Password field
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                SecureField("", text: $password)
                    .textContentType(.password)
                    .textFieldStyle()
            }
            
            // Forgot Password
            HStack {
                Spacer()
                Button("Forgot Password?") {
                    // Handle forgot password
                }
                .font(.subheadline)
                .foregroundColor(Theme.accentColor)
            }
            .padding(.bottom, Theme.spacing)
            
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
                        .fontWeight(.semibold)
                }
            }
            .primaryButtonStyle()
            .disabled(email.isEmpty || password.isEmpty || authManager.isLoading)
            
            // Divider
            HStack {
                VStack { Divider() }
                Text("or")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                VStack { Divider() }
            }
            .padding(.vertical, Theme.spacing)
            
            // Social sign in options
            HStack(spacing: Theme.spacing) {
                Button {
                    // Apple sign in
                } label: {
                    HStack {
                        Image(systemName: "apple.logo")
                        Text("Sign in with Apple")
                    }
                    .fontWeight(.semibold)
                }
                .secondaryButtonStyle()
                
                Button {
                    // Google sign in
                } label: {
                    HStack {
                        Image(systemName: "g.circle.fill")
                        Text("Google")
                    }
                    .fontWeight(.semibold)
                }
                .secondaryButtonStyle()
            }
        }
        .padding()
        .alert("Sign In Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(authManager.error?.localizedDescription ?? "Please try again")
        }
    }
} 