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
        print("Setting up Firebase auth state listener")
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            print("Auth state changed - User: \(user?.uid ?? "nil")")
            self?.isAuthenticated = user != nil
            self?.currentUser = user
        }
    }
    
    func signInWithEmail(email: String, password: String) async throws {
        print("Starting sign in process...")
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            print("Firebase auth successful")
            currentUser = result.user
            isAuthenticated = true
            print("Sign in completed successfully")
        } catch {
            print("Sign in error: \(error.localizedDescription)")
            self.error = error
            throw error
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        isAuthenticated = false
        currentUser = nil
    }
    
    func createAccount(email: String, password: String) async throws {
        print("Starting account creation...")
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = result.user
            print("Firebase auth account created")
            
            // Create user profile in Firestore
            try await Firestore.firestore().collection("users").document(user.uid).setData([
                "email": email,
                "createdAt": Timestamp(),
                "photoURL": ""
            ])
            print("Firestore user document created")
            
            currentUser = user
            isAuthenticated = true
            print("Account creation completed successfully")
        } catch {
            print("Account creation error: \(error.localizedDescription)")
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