import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class TemplateDetailViewModel: ObservableObject {
    @Published var templateName: String
    @Published var templateDescription: String
    @Published var exercises: [ViewTemplateExercise]
    
    private let template: WorkoutTemplate
    private let db = Firestore.firestore()
    
    init(template: WorkoutTemplate) {
        self.template = template
        self.templateName = template.name
        self.templateDescription = template.description
        self.exercises = template.exercises.map { exercise in
            ViewTemplateExercise(exercise: exercise)
        }
    }
    
    func addExercise(_ exercise: Exercise) {
        let templateExercise = TemplateExercise(from: exercise)
        exercises.append(ViewTemplateExercise(exercise: templateExercise))
    }
    
    func removeExercise(at index: Int) {
        exercises.remove(at: index)
    }
    
    func moveExercise(from source: IndexSet, to destination: Int) {
        exercises.move(fromOffsets: source, toOffset: destination)
    }
    
    func saveTemplate() async throws {
        print("Saving template with name: \(templateName)")
        print("Description: \(templateDescription)")
        print("Number of exercises: \(exercises.count)")
        
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "TemplateError", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
        }
        
        let templateExercises = exercises.map { $0.exercise as! TemplateExercise }
        
        // Create document reference first to get the ID
        let docRef = template.id.isEmpty ? 
            db.collection("workoutTemplates").document() :
            db.collection("workoutTemplates").document(template.id)
        
        let updatedTemplate = WorkoutTemplate(
            id: docRef.documentID,
            name: templateName,
            description: templateDescription,
            exercises: templateExercises,
            creatorId: userId,
            creatorName: template.creatorName,
            createdAt: template.createdAt,
            updatedAt: Date()
        )
        
        print("Saving template: \(updatedTemplate)")
        try await docRef.setData(updatedTemplate.asDictionary())
    }
} 