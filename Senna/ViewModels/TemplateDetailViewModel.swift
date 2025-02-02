import Foundation

@MainActor
class TemplateDetailViewModel: ObservableObject {
    @Published var templateName: String
    @Published var templateDescription: String
    @Published var exercises: [ViewTemplateExercise]
    
    private let template: WorkoutTemplate
    
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
        // Implement save functionality
    }
} 