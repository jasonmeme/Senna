import Foundation
import FirebaseFirestore

struct WorkoutPost: Identifiable, Codable {
    let id: String
    let userId: String
    let username: String
    let workoutType: WorkoutType
    let title: String
    let description: String
    let duration: TimeInterval
    let timestamp: Date
    let imageURL: String?
    let likes: Int
    let comments: Int
    
    // Workout-specific details
    let exercises: [CompletedExercise]?  // For strength training
    let distance: Double?                 // For cardio (in meters)
    let pace: Double?                     // For cardio (in seconds per km)
    let elevation: Double?                // For running/cycling
    
    struct CompletedExercise: Codable {
        let name: String
        let sets: [ExerciseSet]
        
        struct ExerciseSet: Codable {
            let weight: Double
            let reps: Int
            let isWarmup: Bool
            let rpe: Int?
        }
    }
    
    var formattedDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
} 
