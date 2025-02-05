import Foundation
import FirebaseFirestore

struct Exercise: Identifiable, Codable {
    let id: String
    var name: String
    var category: ExerciseCategory
    var description: String?
    var muscles: [String]
    var equipment: [String]
    
    // Add any other base exercise properties
    
    // Optional metadata
    var createdAt: Date?
    var updatedAt: Date?
    
    init(
        id: String = UUID().uuidString,
        name: String,
        category: ExerciseCategory,
        description: String? = nil,
        muscles: [String] = [],
        equipment: [String] = [],
        createdAt: Date? = nil,
        updatedAt: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.description = description
        self.muscles = muscles
        self.equipment = equipment
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
} 
