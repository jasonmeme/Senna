import Foundation

struct SetData: Identifiable, Codable {
    var id: String?
    var weight: Double?
    var reps: Int
    var isCompleted: Bool
    
    init(
        id: String = UUID().uuidString,
        weight: Double? = nil,
        reps: Int = ExerciseConstants.defaultReps,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.weight = weight
        self.reps = reps
        self.isCompleted = isCompleted
    }
}

extension SetData {
    func asDictionary() -> [String: Any] {
        [
            "weight": weight as Any,
            "reps": reps,
            "isCompleted": isCompleted
        ]
    }
} 