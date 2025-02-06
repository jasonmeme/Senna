import Foundation
import FirebaseFirestore

struct Workout: Identifiable, Codable {
    let id: String
    var name: String
    var exercises: [WorkoutExercise]
    
    // Template specific
    var description: String?
    var creatorId: String?
    var creatorName: String?
    
    // Active/Completed specific
    var startTime: Date?
    var endTime: Date?
    var duration: TimeInterval?
    var rating: Int?
    var location: String?
    var notes: String?
    
    // State
    var state: WorkoutState
    
    var friends: String?
    
    enum WorkoutState: String, Codable {
        case template
        case active
        case completed
    }
    
    // Codable helpers
    private enum CodingKeys: String, CodingKey {
        case id, name, exercises, description, creatorId, creatorName
        case startTime, endTime, duration, rating, location, notes, state, friends
    }
    
    // Custom init for creating new workouts
    init(
        id: String = UUID().uuidString,
        name: String,
        exercises: [WorkoutExercise] = [],
        description: String? = nil,
        creatorId: String? = nil,
        creatorName: String? = nil,
        startTime: Date? = nil,
        endTime: Date? = nil,
        duration: TimeInterval? = nil,
        rating: Int? = nil,
        location: String? = nil,
        notes: String? = nil,
        friends: String? = nil,
        state: WorkoutState
    ) {
        self.id = id
        self.name = name
        self.exercises = exercises
        self.description = description
        self.creatorId = creatorId
        self.creatorName = creatorName
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.rating = rating
        self.location = location
        self.notes = notes
        self.friends = friends
        self.state = state
    }
    
    // Firebase helpers
    func asDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "name": name,
            "exercises": exercises.map { exercise in
                var exerciseDict = [
                    "id": exercise.id,
                    "exercise": [
                        "id": exercise.exercise.id,
                        "name": exercise.exercise.name,
                        "category": exercise.exercise.category.rawValue,
                        "description": exercise.exercise.description as Any,
                        "muscles": exercise.exercise.muscles,
                        "equipment": exercise.exercise.equipment
                    ],
                    "sets": exercise.sets.map { set in
                        [
                            "id": set.id,
                            "weight": set.weight,
                            "reps": set.reps,
                            "isCompleted": set.isCompleted
                        ]
                    },
                    "restSeconds": exercise.restSeconds,
                    "state": exercise.state.rawValue
                ] as [String: Any]
                
                // Add optional notes if present
                if let notes = exercise.notes {
                    exerciseDict["notes"] = notes
                }
                
                return exerciseDict
            },
            "state": state.rawValue
        ]
        
        // Add optional fields based on state
        switch state {
        case .template:
            if let description = description { dict["description"] = description }
            if let creatorId = creatorId { dict["creatorId"] = creatorId }
            if let creatorName = creatorName { dict["creatorName"] = creatorName }
        case .completed:
            if let duration = duration { dict["duration"] = duration }
            if let startTime = startTime { dict["startTime"] = Timestamp(date: startTime) }
            if let endTime = endTime { dict["endTime"] = Timestamp(date: endTime) }
            if let rating = rating { dict["rating"] = rating }
            if let location = location { dict["location"] = location }
            if let notes = notes { dict["notes"] = notes }
            if let friends = friends { dict["friends"] = friends }
        default:
            break
        }
        
        return dict
    }
} 