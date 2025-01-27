import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    
    private var isFormValid: Bool {
        !email.isEmpty && 
        !password.isEmpty && 
        password.count >= 6
    }
    
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

                    Text("Train together, grow stronger")
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
                            .textContentType(.newPassword)
                            .textFieldStyle()
                        
                        if !password.isEmpty && password.count < 6 {
                            Text("Password must be at least 6 characters")
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.top, 4)
                        }
                    }
                }
                
                // Sign up button
                Button {
                    Task {
                        do {
                            print("Creating account with email: \(email) and password: \(password)")
                            try await createAccount()
                        } catch {
                            showAlert = true
                        }
                    }
                } label: {
                    if authManager.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Create Account")
                            .fontWeight(.semibold)
                    }
                }
                .primaryButtonStyle()
                .disabled(!isFormValid || authManager.isLoading)
                
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
                
                // Terms and Privacy
                Text("By creating an account, you agree to our Terms of Service and Privacy Policy")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, Theme.spacing)
            }
            .padding(.horizontal)
            .padding(.bottom, Theme.spacing * 2)
        }
        .alert("Sign Up Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(authManager.errorMessage ?? "Please try again")
        }
    }
    
    private func createAccount() async throws {
        try await authManager.createAccount(email: email, password: password)
    }
} 
