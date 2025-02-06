import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class FeedViewModel: ObservableObject {
    @Published var posts: [FeedPost] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let db = Firestore.firestore()
    
    func fetchPosts() async {
        isLoading = true
        
        do {
            let snapshot = try await db.collection("workouts")
                .whereField("state", isEqualTo: "completed")
                .order(by: "endTime", descending: true)
                .limit(to: 20)
                .getDocuments()
            
            // Convert to posts
            posts = snapshot.documents.compactMap { document in
                // TODO: Implement proper conversion from document to FeedPost
                // This is a placeholder implementation
                guard let workout = try? document.data(as: Workout.self) else { return nil }
                
                return FeedPost(
                    id: document.documentID,
                    workout: workout,
                    userProfileImageUrl: nil, // TODO: Fetch user profile image
                    username: workout.creatorName ?? "Unknown User",
                    likeCount: 0,
                    commentCount: 0,
                    isLiked: false
                )
            }
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
} 