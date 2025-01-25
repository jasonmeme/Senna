import Foundation
import FirebaseFirestore

@MainActor
class FeedViewModel: ObservableObject {
    @Published var posts: [WorkoutPost] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let db = Firestore.firestore()
    
    func fetchPosts() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let snapshot = try await db.collection("posts")
                .order(by: "timestamp", descending: true)
                .limit(to: 20)
                .getDocuments()
            
            posts = snapshot.documents.compactMap { document -> WorkoutPost? in
                let data = document.data()
                
                // Safely unwrap all required fields
                guard let userId = data["userId"] as? String,
                      let username = data["username"] as? String,
                      let timestamp = data["timestamp"] as? Timestamp,
                      let workoutType = data["workoutType"] as? String,
                      let description = data["description"] as? String else {
                    return nil
                }
                
                // Use default values for optional fields
                let likes = (data["likes"] as? Int) ?? 0
                let comments = (data["comments"] as? Int) ?? 0
                let imageURL = data["imageURL"] as? String
                
                return WorkoutPost(
                    id: document.documentID,
                    userId: userId,
                    username: username,
                    timestamp: timestamp.dateValue(),
                    workoutType: workoutType,
                    description: description,
                    imageURL: imageURL,
                    likes: likes,
                    comments: comments
                )
            }
        } catch {
            self.error = error
        }
    }
} 