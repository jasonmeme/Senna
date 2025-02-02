import Foundation

struct TemplateExercise: Codable {
    let name: String
    var sets: [SetData]
    let restSeconds: Int
    let notes: String?
    let category: ExerciseCategory
    let muscles: [String]
    let equipment: String
    
    init(
        name: String,
        sets: [SetData] = [],
        restSeconds: Int = ExerciseConstants.defaultRestSeconds,
        notes: String? = nil,
        category: ExerciseCategory,
        muscles: [String],
        equipment: String
    ) {
        self.name = name
        self.sets = sets.isEmpty ? 
            Array(repeating: SetData(reps: ExerciseConstants.defaultReps), count: ExerciseConstants.defaultSets) : 
            sets
        self.restSeconds = restSeconds
        self.notes = notes
        self.category = category
        self.muscles = muscles
        self.equipment = equipment
    }
    
    // Convenience initializer to create from Exercise
    init(from exercise: Exercise) {
        self.init(
            name: exercise.name,
            category: exercise.category,
            muscles: exercise.muscles,
            equipment: exercise.equipment.first ?? "bodyweight"
        )
    }
}

extension TemplateExercise: ExerciseData {
    // Already conforms by having all required properties
} 