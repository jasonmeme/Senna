import Foundation

struct SetData: Identifiable, Codable {
    let id: String
    var weight: Double?
    var reps: Int
    
    init(id: String = UUID().uuidString, weight: Double? = nil, reps: Int = ExerciseConstants.defaultReps) {
        self.id = id
        self.weight = weight
        self.reps = reps
    }
} 