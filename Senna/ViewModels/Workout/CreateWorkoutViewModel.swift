import SwiftUI
import FirebaseFirestore
import FirebaseAuth

@MainActor
class CreateWorkoutViewModel: ObservableObject {
    @Published private(set) var templates: [Workout] = []
    @Published private(set) var isLoading = false
    
    private let db = Firestore.firestore()
    
    init() {
        Task {
            await loadTemplates()
        }
    }
    
    func loadTemplates() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let snapshot = try await db
                .collection("workoutTemplates")
                .whereField("creatorId", isEqualTo: Auth.auth().currentUser?.uid ?? "")
                .getDocuments()
            
            templates = snapshot.documents.compactMap { document in
                try? document.data(as: Workout.self)
            }.filter { $0.state == .template }
            
        } catch {
            print("Error loading templates: \(error)")
        }
    }
} 