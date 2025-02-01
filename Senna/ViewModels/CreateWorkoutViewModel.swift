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
    @Published var selectedItem: PhotosPickerItem?
    @Published var selectedImage: Image?
    @Published var includeLocation = false
    @Published var isLoading = false
    @Published var error: Error?
    @Published var showError = false
    @Published var showTemplateSelection = false
    @Published var selectedTemplate: WorkoutTemplate?
    @Published var templates: [WorkoutTemplate] = []
    @Published var recentTemplates: [WorkoutTemplate] = []
    
    private let storage = Storage.storage()
    private let db = Firestore.firestore()
    
    var isValid: Bool {
        !title.isEmpty && !description.isEmpty
    }
    
    init() {
        Task {
            await loadTemplates()
        }
    }
    
    
    func applyTemplate(_ template: WorkoutTemplate) {
        title = template.name
        description = template.description
        exercises = template.exercises.map { templateExercise in
            Exercise(
                id: UUID().uuidString,
                name: templateExercise.name,
                category: .push,
                muscles: [],
                equipment: [templateExercise.equipment],
                createdAt: Date(),
                updatedAt: Date()
            )
        }
    }
    
    func loadTemplates() async {
        isLoading = true
        defer { isLoading = false }
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        do {
            let snapshot = try await db.collection("workoutTemplates")
                .whereField("creatorId", isEqualTo: userId)
                .order(by: "updatedAt", descending: true)
                .getDocuments()
            
            templates = snapshot.documents.compactMap { doc in
                try? doc.data(as: WorkoutTemplate.self)
            }
            
            // Get recent templates (last 3 used)
            recentTemplates = templates.prefix(3).map { $0 }
            
        } catch {
            self.error = error
        }
    }
    
    func createNewTemplate() -> WorkoutTemplate {
        guard let userId = Auth.auth().currentUser?.uid else {
            // Return a dummy template if no user (shouldn't happen in practice)
            return WorkoutTemplate.createNew(creatorId: "unknown", creatorName: "Unknown")
        }
        
        // You might want to fetch the user's name from your user profile
        return WorkoutTemplate.createNew(creatorId: userId, creatorName: "User")
    }
} 
