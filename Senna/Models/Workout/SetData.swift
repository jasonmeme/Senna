import Foundation

struct SetData: Identifiable, Codable {
    let id: String
    var weight: Double
    var reps: Int
    var isCompleted: Bool
    
    init(
        id: String = UUID().uuidString,
        weight: Double = 0.0,
        reps: Int = ExerciseConstants.defaultReps,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.weight = weight
        self.reps = reps
        self.isCompleted = isCompleted
    }
    
    // Custom decoder to handle missing ID in existing data
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Generate new ID if not present in data
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        
        // Handle optional weight with default value
        self.weight = try container.decodeIfPresent(Double.self, forKey: .weight) ?? 0.0
        self.reps = try container.decode(Int.self, forKey: .reps)
        self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, weight, reps, isCompleted
    }
}

extension SetData {
    func asDictionary() -> [String: Any] {
        [
            "id": id,
            "weight": weight,
            "reps": reps,
            "isCompleted": isCompleted
        ]
    }
} 