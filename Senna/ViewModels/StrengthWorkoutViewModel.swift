import SwiftUI
import FirebaseFirestore
import FirebaseAuth

@MainActor
class StrengthWorkoutViewModel: ObservableObject {
    @Published var exercises: [ActiveExercise] = []
    @Published var elapsedTime: TimeInterval = 0
    @Published var showExerciseSearch = false
    @Published var showCancelAlert = false
    @Published var activeRestTimer: RestTimer?
    @Published var completedWorkout: Workout?
    
    private var timer: Timer?
    private var startTime: Date
    private let template: WorkoutTemplate?
    private let db = Firestore.firestore()
    
    init(template: WorkoutTemplate? = nil) {
        self.template = template
        self.startTime = Date()
        
        if let template = template {
            self.exercises = template.exercises.map { exercise in
                ActiveExercise(
                    name: exercise.name,
                    sets: Array(repeating: ExerciseSet(weight: 0, reps: exercise.reps), count: exercise.sets),
                    restSeconds: exercise.restSeconds
                )
            }
        }
        
        startTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
        }
    }
    
    private func updateElapsedTime() {
        elapsedTime = Date().timeIntervalSince(startTime)
    }
    
    func addExercise(_ exercise: Exercise) {
        let newExercise = ActiveExercise(
            name: exercise.name,
            sets: [ExerciseSet(weight: 0, reps: 0)],
            restSeconds: 90
        )
        exercises.append(newExercise)
    }
    
    func startRestTimer(after set: ExerciseSet) {
        guard let exercise = exercises.first(where: { $0.sets.contains(where: { $0.id == set.id }) }) else { return }
        activeRestTimer = RestTimer(duration: exercise.restSeconds)
    }
    
    func finishWorkout() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let totalVolume = exercises.reduce(0.0) { result, exercise in
            result + exercise.sets.reduce(0.0) { setResult, set in
                setResult + (set.weight * Double(set.reps))
            }
        }
        
        let workout = Workout(
            userId: userId,
            title: "Workout",
            description: "Completed workout",
            exercises: exercises.map { exercise in
                Workout.WorkoutExercise(
                    name: exercise.name,
                    sets: exercise.sets.map { set in
                        Workout.ExerciseSet(
                            weight: set.weight,
                            reps: set.reps,
                            isWarmup: set.isWarmup,
                            rpe: set.rpe
                        )
                    },
                    notes: nil
                )
            },
            duration: elapsedTime,
            startTime: startTime,
            endTime: Date(),
            totalVolume: totalVolume
        )
        
        completedWorkout = workout
        timer?.invalidate()
    }
}

struct RestTimer: Identifiable {
    let id = UUID()
    let duration: Int
} 