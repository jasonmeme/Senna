import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class WorkoutHomeViewModel: ObservableObject {
    @Published var recentWorkouts: [Workout] = []
    @Published var userTemplates: [WorkoutTemplate] = []
    @Published var popularTemplates: [WorkoutTemplate] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let db = Firestore.firestore()
    
    func loadData() async {
        isLoading = true
        defer { isLoading = false }
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        do {
            // Fetch recent workouts
            let workoutsSnapshot = try await db.collection("workouts")
                .whereField("userId", isEqualTo: userId)
                .order(by: "timestamp", descending: true)
                .limit(to: 5)
                .getDocuments()
            
            recentWorkouts = workoutsSnapshot.documents.compactMap { doc in
                try? doc.data(as: Workout.self)
            }
            
            // Fetch user templates
            let userTemplatesSnapshot = try await db.collection("workoutTemplates")
                .whereField("creatorId", isEqualTo: userId)
                .getDocuments()
            
            userTemplates = userTemplatesSnapshot.documents.compactMap { doc in
                try? doc.data(as: WorkoutTemplate.self)
            }
            
            // Fetch popular templates
            let popularTemplatesSnapshot = try await db.collection("workoutTemplates")
                .whereField("isPublic", isEqualTo: true)
                .order(by: "saveCount", descending: true)
                .limit(to: 10)
                .getDocuments()
            
            popularTemplates = popularTemplatesSnapshot.documents.compactMap { doc in
                try? doc.data(as: WorkoutTemplate.self)
            }
        } catch {
            self.error = error
        }
    }
} 