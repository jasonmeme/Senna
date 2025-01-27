import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var isEmailFocused = false
    @State private var isPasswordFocused = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Theme.spacing) {
                // Logo and App Name
                VStack(spacing: Theme.spacing) {
                    Image("AppIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .cornerRadius(25)
                    
                    Text("SENNA")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.accentColor)
                    
                    Text("Your strength, your story")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 4)
                    
                }
                .padding(.top, Theme.spacing)
                
                // Form Fields
                VStack(spacing: Theme.spacing) {
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
                }
                
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
                    Text("or continue with")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    VStack { Divider() }
                }
                
                // Social sign in options
                VStack(spacing: Theme.spacing) {
                    Button {
                        // Apple sign in
                    } label: {
                        HStack {
                            Image(systemName: "apple.logo")
                                .imageScale(.medium)
                            Spacer()
                            Text("Continue with Apple")
                            Spacer()
                        }
                        .foregroundColor(.primary)
                        .fontWeight(.medium)
                    }
                    .socialButtonStyle()
                    
                    Button {
                        // Google sign in
                    } label: {
                        HStack {
                            Image(systemName: "g.circle.fill")
                                .imageScale(.medium)
                            Spacer()
                            Text("Continue with Google")
                            Spacer()
                        }
                        .foregroundColor(.primary)
                        .fontWeight(.medium)
                    }
                    .socialButtonStyle()
                }
            }
            .padding(.horizontal)
            .padding(.bottom, Theme.spacing)
        }
        .alert("Sign In Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(authManager.errorMessage ?? "Please try again")
        }
    }
} 