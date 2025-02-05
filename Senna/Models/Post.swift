import Foundation
import FirebaseFirestore

struct Post: Identifiable, Codable {
    let id: String
    let userId: String
    let templateId: String?
    let workout: Workout  // Changed from WorkoutData to Workout
    let notes: String
    let photos: [String]
    let rating: Int
    let location: String?
    let friendTags: [String]
    let timestamp: Date
    
    struct SocialData: Codable {
        var likes: Int
        var comments: [Comment]
        var shares: Int
    }
    
    var socialData: SocialData
    
    struct Comment: Identifiable, Codable {
        let id: String
        let userId: String
        let text: String
        let timestamp: Date
    }
    
    // Codable helpers
    private enum CodingKeys: String, CodingKey {
        case id, userId, templateId, workout, notes, photos, rating, location, friendTags, timestamp, socialData
    }
    
    func asDictionary() -> [String: Any] {
        [
            "id": id,
            "userId": userId,
            "templateId": templateId as Any,
            "workout": workout.asDictionary(),
            "notes": notes,
            "photos": photos,
            "rating": rating,
            "location": location as Any,
            "friendTags": friendTags,
            "timestamp": Timestamp(date: timestamp),
            "socialData": [
                "likes": socialData.likes,
                "comments": socialData.comments.map { $0.asDictionary() },
                "shares": socialData.shares
            ]
        ]
    }
}

extension Post.Comment {
    func asDictionary() -> [String: Any] {
        [
            "id": id,
            "userId": userId,
            "text": text,
            "timestamp": Timestamp(date: timestamp)
        ]
    }
}
