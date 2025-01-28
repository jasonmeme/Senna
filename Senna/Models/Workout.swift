import Foundation
import FirebaseFirestore

struct Workout: Identifiable, Codable {
    let id: String
    let userId: String
    let title: String
    let description: String
    let exercises: [WorkoutExercise]
    let duration: TimeInterval
    let startTime: Date
    let endTime: Date?
    let totalVolume: Double
    let templateId: String?
    let imageURLs: [String]
    let location: GeoPoint?
    
    struct WorkoutExercise: Codable {
        let name: String
        let sets: [ExerciseSet]
        let notes: String?
    }
    
    struct ExerciseSet: Codable {
        let weight: Double
        let reps: Int
        let isWarmup: Bool
        let rpe: Int?
    }
    
    init(id: String = UUID().uuidString,
         userId: String,
         title: String,
         description: String,
         exercises: [WorkoutExercise],
         duration: TimeInterval,
         startTime: Date,
         endTime: Date? = nil,
         totalVolume: Double,
         templateId: String? = nil,
         imageURLs: [String] = [],
         location: GeoPoint? = nil) {
        self.id = id
        self.userId = userId
        self.title = title
        self.description = description
        self.exercises = exercises
        self.duration = duration
        self.startTime = startTime
        self.endTime = endTime
        self.totalVolume = totalVolume
        self.templateId = templateId
        self.imageURLs = imageURLs
        self.location = location
    }
} 