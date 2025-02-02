import Foundation

struct TemplateExercise: Codable, Identifiable {
    let id: String
    let name: String
    var sets: [SetData]
    let restSeconds: Int
    let notes: String?
    let category: ExerciseCategory
    let muscles: [String]
    let equipment: String
    
    init(
        id: String = UUID().uuidString,
        name: String,
        sets: [SetData] = [],
        restSeconds: Int = ExerciseConstants.defaultRestSeconds,
        notes: String? = nil,
        category: ExerciseCategory,
        muscles: [String],
        equipment: String
    ) {
        self.id = id
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
            id: UUID().uuidString,
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

extension TemplateExercise {
    func asDictionary() -> [String: Any] {
        [
            "id": id,
            "name": name,
            "sets": sets.map { $0.asDictionary() },
            "restSeconds": restSeconds,
            "notes": notes as Any,
            "category": category.rawValue,
            "muscles": muscles,
            "equipment": equipment
        ]
    }
    
    // Add a coding keys enum to handle missing id
    private enum CodingKeys: String, CodingKey {
        case id, name, sets, restSeconds, notes, category, muscles, equipment
    }
    
    // Custom decoder init to handle missing id
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Try to decode id, generate new one if missing
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        self.name = try container.decode(String.self, forKey: .name)
        self.sets = try container.decode([SetData].self, forKey: .sets)
        self.restSeconds = try container.decode(Int.self, forKey: .restSeconds)
        self.notes = try container.decodeIfPresent(String.self, forKey: .notes)
        self.category = try container.decode(ExerciseCategory.self, forKey: .category)
        self.muscles = try container.decode([String].self, forKey: .muscles)
        self.equipment = try container.decode(String.self, forKey: .equipment)
    }
} 
