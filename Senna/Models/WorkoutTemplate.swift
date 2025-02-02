import Foundation
import FirebaseFirestore

struct WorkoutTemplate: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let exercises: [TemplateExercise]
    let creatorId: String
    let creatorName: String
    let createdAt: Date
    let updatedAt: Date
    
    static func createNew(creatorId: String, creatorName: String) -> WorkoutTemplate {
        WorkoutTemplate(
            id: "",
            name: "",
            description: "",
            exercises: [],
            creatorId: creatorId,
            creatorName: creatorName,
            createdAt: Date(),
            updatedAt: Date()
        )
    }
    
    func asDictionary() -> [String: Any] {
        [
            "id": id,
            "name": name,
            "description": description,
            "exercises": exercises.map { $0.asDictionary() },
            "creatorId": creatorId,
            "creatorName": creatorName,
            "createdAt": Timestamp(date: createdAt),
            "updatedAt": Timestamp(date: updatedAt)
        ]
    }
} 