import SwiftUI
import FirebaseAuth
import PhotosUI
import FirebaseFirestore
import FirebaseStorage

@MainActor
class CreateWorkoutViewModel: ObservableObject {
    @Published var workoutType = WorkoutType.strength
    @Published var description = ""
    @Published var selectedItem: PhotosPickerItem?
    @Published var selectedImage: Image?
    @Published var includeLocation = false
    @Published var isLoading = false
    @Published var error: Error?
    @Published var showError = false
    
    private let storage = Storage.storage()
    private let db = Firestore.firestore()
    
    var isValid: Bool {
        !description.isEmpty
    }
    
    func createPost() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            var imageURL: String?
            if let selectedItem = selectedItem {
                imageURL = try await uploadImage(selectedItem)
            }
            
            let post = [
                "workoutType": workoutType.rawValue,
                "description": description,
                "imageURL": imageURL,
                "timestamp": Timestamp(),
                "likes": 0,
                "comments": 0,
                "userId": Auth.auth().currentUser?.uid ?? "",
                "username": "User" // Replace with actual username from user profile
            ] as [String: Any]
            
            try await db.collection("posts").addDocument(data: post)
        } catch {
            self.error = error
            self.showError = true
        }
    }
    
    private func uploadImage(_ item: PhotosPickerItem) async throws -> String {
        let data = try await item.loadTransferable(type: Data.self) ?? Data()
        let fileRef = storage.reference().child("workout_images/\(UUID().uuidString).jpg")
        
        _ = try await fileRef.putDataAsync(data)
        let url = try await fileRef.downloadURL()
        return url.absoluteString
    }
    
    // Add this function to handle image selection
    func loadImage() async {
        guard let item = selectedItem else { return }
        guard let data = try? await item.loadTransferable(type: Data.self),
              let uiImage = UIImage(data: data) else {
            return
        }
        selectedImage = Image(uiImage: uiImage)
    }
} 
