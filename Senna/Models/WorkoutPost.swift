import Foundation
import FirebaseFirestore

struct WorkoutPost: Identifiable {
    let id: String
    let userId: String
    let username: String
    let timestamp: Date
    let workoutType: String
    let description: String
    let imageURL: String?
    let likes: Int
    let comments: Int
    
    var formattedDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
} 