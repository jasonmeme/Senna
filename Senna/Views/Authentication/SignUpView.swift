import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var username = ""
    @State private var showAlert = false
    
    private var isFormValid: Bool {
        !email.isEmpty && 
        !password.isEmpty && 
        !username.isEmpty && 
        password == confirmPassword &&
        password.count >= 6
    }
    
    var body: some View {
        VStack(spacing: Theme.spacing * 1.5) {
            // Logo and Welcome Text
            VStack(spacing: 8) {
                Image("AppIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(20)
                
                Text("Create Account")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Join the fitness community")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, Theme.spacing)
            
            // Username field
            VStack(alignment: .leading, spacing: 8) {
                Text("Username")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextField("", text: $username)
                    .textContentType(.username)
                    .autocapitalization(.none)
                    .textFieldStyle()
            }
            
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
                }
            }
            
            // Confirm Password field
            VStack(alignment: .leading, spacing: 8) {
                Text("Confirm Password")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                SecureField("", text: $confirmPassword)
                    .textContentType(.newPassword)
                    .textFieldStyle()
                
                if !confirmPassword.isEmpty && password != confirmPassword {
                    Text("Passwords do not match")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            // Sign up button
            Button {
                Task {
                    do {
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
            .padding(.top, Theme.spacing)
            
            // Terms and Privacy
            Text("By creating an account, you agree to our Terms of Service and Privacy Policy")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .alert("Sign Up Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(authManager.error?.localizedDescription ?? "Please try again")
        }
    }
    
    private func createAccount() async throws {
        try await authManager.createAccount(email: email, password: password, username: username)
    }
} 