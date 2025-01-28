import SwiftUI
import FirebaseAuth
import PhotosUI
import FirebaseFirestore
import FirebaseStorage

@MainActor
class CreateWorkoutViewModel: ObservableObject {
    @Published var workoutType = WorkoutType.strength
    @Published var title = ""
    @Published var description = ""
    @Published var exercises: [Exercise] = []
    @Published var selectedItem: PhotosPickerItem?
    @Published var selectedImage: Image?
    @Published var includeLocation = false
    @Published var isLoading = false
    @Published var error: Error?
    @Published var showError = false
    @Published var showTemplateSelection = false
    @Published var selectedTemplate: WorkoutTemplate?
    
    private let storage = Storage.storage()
    private let db = Firestore.firestore()
    
    var isValid: Bool {
        !title.isEmpty && !description.isEmpty
    }
    
    func createWorkout() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            var imageURL: String?
            if let selectedItem = selectedItem {
                imageURL = try await uploadImage(selectedItem)
            }
            
            guard let userId = Auth.auth().currentUser?.uid else { return }
            
            // Convert exercises to WorkoutExercise format
            let workoutExercises = exercises.map { exercise in
                Workout.WorkoutExercise(
                    name: exercise.name,
                    sets: [],  // Empty sets for now
                    notes: nil
                )
            }
            
            let workout = Workout(
                userId: userId,
                title: title,
                description: description,
                exercises: workoutExercises,
                duration: 0,  // No duration for created workout
                startTime: Date(),
                endTime: nil,
                totalVolume: 0,  // No volume for created workout
                imageURLs: imageURL.map { [$0] } ?? []
            )
            
            try await db.collection("workouts").document(workout.id).setData([
                "userId": workout.userId,
                "title": workout.title,
                "description": workout.description,
                "exercises": workout.exercises.map { exercise in
                    [
                        "name": exercise.name,
                        "sets": [],
                        "notes": nil
                    ]
                },
                "duration": workout.duration,
                "startTime": workout.startTime,
                "endTime": workout.endTime as Any,
                "totalVolume": workout.totalVolume,
                "imageURLs": workout.imageURLs
            ])
            
        } catch {
            self.error = error
            self.showError = true
        }
    }
    
    private func uploadImage(_ item: PhotosPickerItem) async throws -> String {
        guard let data = try await item.loadTransferable(type: Data.self) else {
            throw URLError(.badServerResponse)
        }
        
        let storageRef = storage.reference().child("workout_images/\(UUID().uuidString).jpg")
        let _ = try await storageRef.putDataAsync(data)
        let downloadURL = try await storageRef.downloadURL()
        return downloadURL.absoluteString
    }
    
    func loadImage() async {
        guard let item = selectedItem else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        selectedImage = Image(uiImage: uiImage)
    }
    
    func applyTemplate(_ template: WorkoutTemplate) {
        title = template.name
        description = template.description
        exercises = template.exercises.map { templateExercise in
            Exercise(
                name: templateExercise.name,
                category: .other,  // You might want to store category in TemplateExercise
                isCustom: false
            )
        }
    }
} 
