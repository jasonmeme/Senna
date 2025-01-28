import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@MainActor
class WorkoutTemplatesViewModel: ObservableObject {
    @Published var userTemplates: [WorkoutTemplate] = []
    @Published var popularTemplates: [WorkoutTemplate] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let db = Firestore.firestore()
    
    func loadTemplates() async {
        isLoading = true
        defer { isLoading = false }
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        do {
            // Fetch user's templates
            let userSnapshot = try await db.collection("workoutTemplates")
                .whereField("creatorId", isEqualTo: userId)
                .getDocuments()
            
            userTemplates = userSnapshot.documents.compactMap { doc in
                try? doc.data(as: WorkoutTemplate.self)
            }
            
            // Fetch popular templates
            let popularSnapshot = try await db.collection("workoutTemplates")
                .whereField("isPublic", isEqualTo: true)
                .order(by: "saveCount", descending: true)
                .limit(to: 20)
                .getDocuments()
            
            popularTemplates = popularSnapshot.documents.compactMap { doc in
                try? doc.data(as: WorkoutTemplate.self)
            }
        } catch {
            self.error = error
        }
    }
} 
