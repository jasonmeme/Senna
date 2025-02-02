import Foundation

struct ActiveExercise: Identifiable {
    let id: String
    let name: String
    var sets: [SetData]
    
    init(from templateExercise: TemplateExercise) {
        self.id = templateExercise.id
        self.name = templateExercise.name
        self.sets = templateExercise.sets
    }
} 