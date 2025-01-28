import Foundation

struct Exercise: Identifiable, Codable {
    let id: String
    let name: String
    let category: ExerciseCategory
    let isCustom: Bool
    let userId: String?
    
    init(id: String = UUID().uuidString,
         name: String,
         category: ExerciseCategory,
         isCustom: Bool = false,
         userId: String? = nil) {
        self.id = id
        self.name = name
        self.category = category
        self.isCustom = isCustom
        self.userId = userId
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "name": name,
            "category": category.rawValue,
            "isCustom": isCustom
        ]
        
        if let userId = userId {
            dict["userId"] = userId
        }
        
        return dict
    }
}

enum ExerciseCategory: String, CaseIterable, Identifiable, Codable {
    case chest = "Chest"
    case back = "Back"
    case legs = "Legs"
    case shoulders = "Shoulders"
    case arms = "Arms"
    case core = "Core"
    case cardio = "Cardio"
    case other = "Other"
    
    var id: String { rawValue }
    var name: String { rawValue }
}

enum WorkoutType: String, CaseIterable, Identifiable, Codable {
    case strength = "Strength Training"
    case running = "Running"
    case cycling = "Cycling"
    case swimming = "Swimming"
    case yoga = "Yoga"
    case hiit = "HIIT"
    case other = "Other"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .strength: return "dumbbell.fill"
        case .running: return "figure.run"
        case .cycling: return "bicycle"
        case .swimming: return "figure.pool.swim"
        case .yoga: return "figure.mind.and.body"
        case .hiit: return "timer"
        case .other: return "sparkles"
        }
    }
} 