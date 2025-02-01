import Foundation

enum ExerciseCategory: String, Codable {
    case push = "push"
    case pull = "pull"
    case legs = "legs"
    case core = "core"
    
    var icon: String {
        switch self {
        case .push: return "arrow.up.circle.fill"
        case .pull: return "arrow.down.circle.fill"
        case .legs: return "figure.walk.circle.fill"
        case .core: return "circle.circle.fill"
        }
    }
} 