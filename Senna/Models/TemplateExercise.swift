import Foundation

struct TemplateExercise: Codable {
    let name: String
    let sets: Int
    let reps: Int
    let restSeconds: Int
    let notes: String?
    let category: ExerciseCategory
    let muscles: [String]
    let equipment: String
    
    init(
        name: String,
        sets: Int = 3,
        reps: Int = 10,
        restSeconds: Int = 60,
        notes: String? = nil,
        category: ExerciseCategory,
        muscles: [String],
        equipment: String
    ) {
        self.name = name
        self.sets = sets
        self.reps = reps
        self.restSeconds = restSeconds
        self.notes = notes
        self.category = category
        self.muscles = muscles
        self.equipment = equipment
    }
    
    // Convenience initializer to create from Exercise
    init(from exercise: Exercise, sets: Int = 3, reps: Int = 10, restSeconds: Int = 60) {
        self.init(
            name: exercise.name,
            sets: sets,
            reps: reps,
            restSeconds: restSeconds,
            category: exercise.category,
            muscles: exercise.muscles,
            equipment: exercise.equipment.first ?? "bodyweight"
        )
    }
} 