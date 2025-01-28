import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class ExerciseSearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var selectedCategory: ExerciseCategory?
    @Published var exercises: [Exercise] = []
    @Published var showCreateExercise = false
    @Published var isLoading = false
    @Published var error: Error?
    
    private let db = Firestore.firestore()
    
    var filteredExercises: [Exercise] {
        exercises.filter { exercise in
            let matchesSearch = searchText.isEmpty || 
                exercise.name.localizedCaseInsensitiveContains(searchText)
            let matchesCategory = selectedCategory == nil || 
                exercise.category == selectedCategory
            return matchesSearch && matchesCategory
        }
    }
    
    init() {
        Task {
            await loadExercises()
        }
    }
    
    func loadExercises() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Load default exercises
            let defaultSnapshot = try await db.collection("exercises")
                .whereField("isCustom", isEqualTo: false)
                .getDocuments()
            
            var loadedExercises: [Exercise] = defaultSnapshot.documents.compactMap { doc -> Exercise? in
                let data = doc.data()
                guard let name = data["name"] as? String,
                      let categoryString = data["category"] as? String,
                      let category = ExerciseCategory(rawValue: categoryString) else {
                    return nil
                }
                
                return Exercise(
                    id: doc.documentID,
                    name: name,
                    category: category,
                    isCustom: false
                )
            }
            
            // Load user's custom exercises
            if let userId = Auth.auth().currentUser?.uid {
                let customSnapshot = try await db.collection("exercises")
                    .whereField("isCustom", isEqualTo: true)
                    .whereField("userId", isEqualTo: userId)
                    .getDocuments()
                
                let customExercises = customSnapshot.documents.compactMap { doc -> Exercise? in
                    let data = doc.data()
                    guard let name = data["name"] as? String,
                          let categoryString = data["category"] as? String,
                          let category = ExerciseCategory(rawValue: categoryString) else {
                        return nil
                    }
                    
                    return Exercise(
                        id: doc.documentID,
                        name: name,
                        category: category,
                        isCustom: true,
                        userId: userId
                    )
                }
                
                loadedExercises.append(contentsOf: customExercises)
            }
            
            exercises = loadedExercises.sorted { $0.name < $1.name }
        } catch {
            self.error = error
        }
    }
    
    func addCustomExercise(_ exercise: Exercise) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        Task {
            do {
                try await db.collection("exercises").document(exercise.id).setData([
                    "name": exercise.name,
                    "category": exercise.category.rawValue,
                    "isCustom": true,
                    "userId": userId
                ])
                
                await loadExercises()
            } catch {
                self.error = error
            }
        }
    }
} 