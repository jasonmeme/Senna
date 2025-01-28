import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile?
    
    func fetchProfile() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        do {
            let document = try await Firestore.firestore().collection("users").document(userId).getDocument()
            guard let data = document.data() else { return }
            
            profile = UserProfile(
                email: data["email"] as? String ?? "",
                fullName: data["fullName"] as? String ?? "Complete Your Profile",
                age: data["age"] as? Int ?? 0,
                gender: data["gender"] as? String ?? "Not specified",
                fitnessLevel: data["fitnessLevel"] as? String ?? "Not specified"
            )
        } catch {
            print("Error fetching profile: \(error.localizedDescription)")
        }
    }
} 