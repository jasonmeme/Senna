import SwiftUI
import FirebaseFirestore

@MainActor
class ExerciseSearchViewModel: ObservableObject {
    @Published var exercises: [Exercise] = []
    @Published var searchText = ""
    @Published private(set) var isLoading = false
    
    var filteredExercises: [Exercise] {
        if searchText.isEmpty {
            return exercises
        }
        return exercises.filter { exercise in
            exercise.name.localizedCaseInsensitiveContains(searchText) ||
            exercise.muscles.contains(where: { $0.localizedCaseInsensitiveContains(searchText) })
        }
    }
    
    init() {
        Task {
            await fetchExercises()
        }
    }
    
    func fetchExercises() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let snapshot = try await Firestore.firestore()
                .collection("exercises")
                .getDocuments()
            exercises = snapshot.documents.compactMap { document in
                try? document.data(as: Exercise.self)
            }
        } catch {
            print("Error fetching exercises: \(error)")
        }
    }
} 
