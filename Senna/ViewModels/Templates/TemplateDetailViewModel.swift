import SwiftUI
import FirebaseFirestore
import FirebaseAuth

@MainActor
class TemplateDetailViewModel: ObservableObject {
    @Published var template: Workout
    private let db = Firestore.firestore()
    
    var isValid: Bool {
        !template.name.isEmpty && !template.exercises.isEmpty
    }
    
    init(template: Workout?) {
        if let template = template {
            self.template = template
        } else {
            // Create new template
            self.template = Workout(
                id: UUID().uuidString,
                name: "",
                exercises: [],
                state: .template
            )
        }
    }
    
    func addExercise(_ exercise: Exercise) {
        let workoutExercise = WorkoutExercise(from: exercise)
        template.exercises.append(workoutExercise)
    }
    
    func removeExercise(at index: Int) {
        template.exercises.remove(at: index)
    }
    
    func moveExercise(from source: IndexSet, to destination: Int) {
        template.exercises.move(fromOffsets: source, toOffset: destination)
    }
    
    func saveTemplate() async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
        }
        
        template.creatorId = userId
        template.creatorName = Auth.auth().currentUser?.displayName ?? "Unknown"
        
        let docRef = db.collection("workoutTemplates").document(template.id)
        try await docRef.setData(template.asDictionary())
    }
} 