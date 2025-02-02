import Foundation

struct ViewTemplateExercise: Identifiable {
    let id: String
    let exercise: ExerciseData
    
    init(id: String = UUID().uuidString, exercise: ExerciseData) {
        self.id = id
        self.exercise = exercise
    }
    
    // Convenience properties to access exercise properties
    var name: String { exercise.name }
    var sets: [SetData] { exercise.sets }
    var equipment: String { exercise.equipment }
    var restSeconds: Int { exercise.restSeconds }
    var notes: String? { exercise.notes }
    var category: ExerciseCategory { exercise.category }
    var muscles: [String] { exercise.muscles }
} 