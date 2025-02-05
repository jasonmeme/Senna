import SwiftUI
import FirebaseFirestore

@MainActor
class TemplateViewModel: ObservableObject {
    @Published var template: Workout
    private let db = Firestore.firestore()
    private let authManager = AuthenticationManager.shared
    
    var isValid: Bool {
        !template.name.isEmpty && !template.exercises.isEmpty
    }
    
    init(template: Workout?) {
        if let template = template {
            self.template = template
        } else {
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
        guard let user = try? authManager.getUser() else {
            throw AuthenticationError.notAuthenticated
        }
        
        template.creatorId = user.uid
        template.creatorName = user.displayName ?? "Unknown"
        
        let docRef = db.collection("workoutTemplates").document(template.id)
        try await docRef.setData(template.asDictionary())
    }
} 