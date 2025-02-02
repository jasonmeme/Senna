import Foundation

@MainActor
class ActiveWorkoutViewModel: ObservableObject {
    @Published var exercises: [ActiveExercise]
    @Published var elapsedTime: TimeInterval = 0
    private var timer: Timer?
    
    init(template: WorkoutTemplate? = nil) {
        if let template = template {
            self.exercises = template.exercises.map { ActiveExercise(from: $0) }
        } else {
            self.exercises = []
        }
        startTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.elapsedTime += 1
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}