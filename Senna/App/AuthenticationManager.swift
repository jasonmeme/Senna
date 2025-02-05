import SwiftUI
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

@MainActor
final class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isProfileComplete = false
    @Published var isInitializing = true
    
    private init() {
        setupFirebaseAuthStateListener()
    }
    
    private func setupFirebaseAuthStateListener() {
        print("Setting up Firebase auth state listener")
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            print("Auth state changed - User: \(user?.uid ?? "nil")")
            self?.isAuthenticated = user != nil
            self?.currentUser = user
            if user != nil {
                Task {
                    await self?.fetchUserProfile()
                }
            }
            self?.isInitializing = false
        }
    }
    
    func getUser() throws -> User {
        guard let user = Auth.auth().currentUser else {
            throw AuthenticationError.notAuthenticated
        }
        return user
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
            self.errorMessage = error.localizedDescription
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
            self.errorMessage = error.localizedDescription
            throw error
        }
    }
    
    func signInWithApple() async throws {
        // Implement Apple Sign In
    }
    
    func signInWithGoogle() async throws {
        // Implement Google Sign In
    }
    
    func fetchUserProfile() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        do {
            let document = try await Firestore.firestore().collection("users").document(userId).getDocument()
            isProfileComplete = (document.data()?["profileCompleted"] as? Bool) ?? false
        } catch {
            print("Error fetching user profile: \(error.localizedDescription)")
        }
    }
} 