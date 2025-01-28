import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class FeedViewModel: ObservableObject {
    @Published var posts: [WorkoutPost] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let db = Firestore.firestore()
    
    func loadPosts() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let snapshot = try await db.collection("posts")
                .order(by: "timestamp", descending: true)
                .limit(to: 20)
                .getDocuments()
            
            posts = snapshot.documents.compactMap { doc in
                try? doc.data(as: WorkoutPost.self)
            }
        } catch {
            self.error = error
        }
    }
    
    func createPost(from workout: Workout) async throws {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let post = WorkoutPost(
            id: UUID().uuidString,
            userId: userId,
            username: "User", // You might want to fetch this from UserProfile
            workoutType: .strength, // Assuming strength workout for now
            title: workout.title,
            description: workout.description,
            duration: workout.duration,
            timestamp: Date(),
            imageURL: workout.imageURLs.first,
            likes: 0,
            comments: 0,
            exercises: workout.exercises.map { exercise in
                WorkoutPost.CompletedExercise(
                    name: exercise.name,
                    sets: exercise.sets.map { set in
                        WorkoutPost.CompletedExercise.ExerciseSet(
                            weight: set.weight,
                            reps: set.reps,
                            isWarmup: set.isWarmup,
                            rpe: set.rpe
                        )
                    }
                )
            },
            distance: nil,
            pace: nil,
            elevation: nil
        )
        
        try await db.collection("posts").document(post.id).setData(from: post)
    }
} 