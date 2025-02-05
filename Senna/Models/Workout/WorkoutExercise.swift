struct WorkoutExercise: Identifiable, Codable {
    var id: String { exercise.id }
    var exercise: Exercise
    var sets: [SetData]
    var state: ExerciseState
    var restSeconds: Int = ExerciseConstants.defaultRestSeconds
    var notes: String?
    
    init(from exercise: Exercise) {
        self.exercise = exercise
        self.sets = Array(repeating: SetData(), count: ExerciseConstants.defaultSets)
        self.state = .active
    }
    
    enum ExerciseState: String, Codable {
        case active
        case completed
    }
}

// Add property forwarding for convenience
extension WorkoutExercise {
    var name: String { exercise.name }
    var category: ExerciseCategory { exercise.category }
    var description: String? { exercise.description }
    var muscles: [String] { exercise.muscles }
    var equipment: [String] { exercise.equipment }
} 
