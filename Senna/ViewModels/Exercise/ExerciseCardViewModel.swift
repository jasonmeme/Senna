import Foundation

@MainActor
class ExerciseCardViewModel: ObservableObject {
    @Published var sets: [SetData]
    let exercise: ViewTemplateExercise
    
    init(exercise: ViewTemplateExercise) {
        self.exercise = exercise
        self.sets = exercise.exercise.sets
    }
    
    func addSet() {
        let lastReps = sets.last?.reps ?? ExerciseConstants.defaultReps
        let lastWeight = sets.last?.weight ?? 0.0  // Use default weight if no previous set
        let newSet = SetData(weight: lastWeight, reps: lastReps)
        sets.append(newSet)
    }
    
    func removeSet(at index: Int) {
        guard sets.indices.contains(index) else { return }
        sets.remove(at: index)
    }
    
    func updateWeight(at index: Int, text: String) {
        guard sets.indices.contains(index) else { return }
        if let weight = Double(text) {
            sets[index].weight = weight
        }
    }
    
    func updateReps(at index: Int, reps: Int) {
        guard sets.indices.contains(index) else { return }
        sets[index].reps = reps
    }
    
    func updateCompletion(at index: Int, isCompleted: Bool) {
        guard sets.indices.contains(index) else { return }
        sets[index].isCompleted = isCompleted
    }
} 