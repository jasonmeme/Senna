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
        VStack(spacing: Theme.spacing) {
            TextField("Username", text: $username)
                .textContentType(.username)
                .autocapitalization(.none)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 300)
            
            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 300)
            
            SecureField("Password", text: $password)
                .textContentType(.newPassword)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 300)
            
            SecureField("Confirm Password", text: $confirmPassword)
                .textContentType(.newPassword)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 300)
            
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
                        .frame(maxWidth: 300)
                }
            }
            .primaryButtonStyle()
            .disabled(!isFormValid || authManager.isLoading)
        }
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