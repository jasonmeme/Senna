import Foundation
import FirebaseFirestore

struct Exercise: Identifiable, Codable {
    let id: String
    let name: String
    let category: ExerciseCategory
    let muscles: [String]
    let equipment: [String]
    let createdAt: Date?
    let updatedAt: Date?
} 