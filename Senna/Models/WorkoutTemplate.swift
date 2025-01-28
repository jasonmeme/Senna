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
    
    struct TemplateExercise: Codable {
        let name: String
        let sets: Int
        let reps: Int
        let restSeconds: Int
        let notes: String?
    }
} 