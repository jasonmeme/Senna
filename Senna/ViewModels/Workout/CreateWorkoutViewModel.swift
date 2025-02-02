import SwiftUI
import FirebaseAuth
import PhotosUI
import FirebaseFirestore
import FirebaseStorage

@MainActor
class CreateWorkoutViewModel: ObservableObject {
    @Published var title = ""
    @Published var description = ""
    @Published var exercises: [Exercise] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var showError = false
    @Published var templates: [WorkoutTemplate] = []
    
    private let db = Firestore.firestore()
    
    init() {
        Task {
            await loadTemplates()
        }
    }
    
    func loadTemplates() async {
        print("Loading templates...")
        isLoading = true
        defer { isLoading = false }
        
        guard let userId = Auth.auth().currentUser?.uid else {
            return 
        }
        
        do {
            let snapshot = try await db.collection("workoutTemplates")
                .whereField("creatorId", isEqualTo: userId)
                .order(by: "updatedAt", descending: true)
                .getDocuments()
            
            print("Raw documents: \(snapshot.documents.map { $0.data() })")
            templates = snapshot.documents.compactMap { doc in
                do {
                    let template = try doc.data(as: WorkoutTemplate.self)
                    print("Successfully decoded template: \(template.name)")
                    return template
                } catch {
                    print("Failed to decode template: \(error)")
                    return nil
                }
            }

            print("Loaded templates: \(templates.count)")
            templates.forEach { template in
                print("Template: \(template.name), Exercises: \(template.exercises.count)")
            }
        } catch {
            self.error = error
            showError = true
        }
    }
    
    func createNewTemplate() -> WorkoutTemplate {
        guard let userId = Auth.auth().currentUser?.uid else {
            return WorkoutTemplate.createNew(creatorId: "unknown", creatorName: "Unknown")
        }
        // TODO: Get user name
        return WorkoutTemplate.createNew(creatorId: userId, creatorName: "User")
    }
} 
