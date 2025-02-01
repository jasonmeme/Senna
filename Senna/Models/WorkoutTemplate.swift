import Foundation
import FirebaseFirestore

struct WorkoutTemplate: Identifiable, Codable {
    let id: String
    let name: String
    let creatorId: String
    let creatorName: String
    let description: String
    let exercises: [TemplateExercise]
    let imageURL: String?
    let isPublic: Bool
    let saveCount: Int
    let usageCount: Int
    let rating: Double
    let createdAt: Date
    let updatedAt: Date
}

extension WorkoutTemplate {
    static func createNew(creatorId: String, creatorName: String) -> WorkoutTemplate {
        WorkoutTemplate(
            id: UUID().uuidString,
            name: "New Template",
            creatorId: creatorId,
            creatorName: creatorName,
            description: "",
            exercises: [],
            imageURL: nil,
            isPublic: false,
            saveCount: 0,
            usageCount: 0,
            rating: 0,
            createdAt: Date(),
            updatedAt: Date()
        )
    }
} 