struct TemplateExercise: Identifiable, Codable {
    var id: String { exercise.id }
    var exercise: Exercise
    var targetSets: Int
    var targetReps: Int
    
    init(from exercise: Exercise, targetSets: Int = 3, targetReps: Int = 10) {
        self.exercise = exercise
        self.targetSets = targetSets
        self.targetReps = targetReps
    }
}

// Add property forwarding for convenience
extension TemplateExercise {
    var name: String { exercise.name }
    var category: ExerciseCategory { exercise.category }
    var description: String? { exercise.description }
} 