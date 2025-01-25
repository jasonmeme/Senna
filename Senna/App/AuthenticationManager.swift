import SwiftUI
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

@MainActor
class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var error: Error?
    
    init() {
        setupFirebaseAuthStateListener()
    }
    
    private func setupFirebaseAuthStateListener() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isAuthenticated = user != nil
            self?.currentUser = user
        }
    }
    
    func signInWithEmail(email: String, password: String) async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            currentUser = result.user
            isAuthenticated = true
        } catch {
            self.error = error
            throw error
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        isAuthenticated = false
        currentUser = nil
    }
    
    func createAccount(email: String, password: String, username: String) async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = result.user
            
            // Create user profile in Firestore
            try await Firestore.firestore().collection("users").document(user.uid).setData([
                "username": username,
                "email": email,
                "createdAt": Timestamp(),
                "photoURL": ""
            ])
            
            currentUser = user
            isAuthenticated = true
        } catch {
            self.error = error
            throw error
        }
    }
    
    func signInWithApple() async throws {
        // Implement Apple Sign In
    }
    
    func signInWithGoogle() async throws {
        // Implement Google Sign In
    }
} 