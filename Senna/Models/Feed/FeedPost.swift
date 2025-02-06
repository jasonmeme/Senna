import Foundation

struct FeedPost: Identifiable {
    let id: String
    let workout: Workout
    let userProfileImageUrl: String?
    let username: String
    var likeCount: Int
    var commentCount: Int
    var isLiked: Bool
    
    // Computed properties for convenience
    var timestamp: Date? { workout.endTime }
    var duration: TimeInterval? { workout.duration }
    var exerciseCount: Int { workout.exercises.count }
    var totalSets: Int { workout.exercises.reduce(0) { $0 + $1.sets.count } }
} 