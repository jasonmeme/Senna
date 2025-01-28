import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class ActiveWorkoutViewModel: ObservableObject {
    @Published var exercises: [ActiveExercise] = []
    @Published var elapsedTime: TimeInterval = 0
    @Published var isWorkoutActive = true
    @Published var showExerciseSearch = false
    @Published var showCancelAlert = false
    @Published var showWorkoutComplete = false
    @Published var completedWorkout: Workout?
    
    private var timer: Timer?
    private let startTime = Date()
    
    init() {
        startTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    private func updateTimer() {
        elapsedTime = Date().timeIntervalSince(startTime)
    }
    
    func addExercise(_ exercise: Exercise) {
        let activeExercise = ActiveExercise(
            name: exercise.name,
            sets: [ExerciseSet(weight: 0, reps: 0)],
            restSeconds: 90
        )
        exercises.append(activeExercise)
    }
    
    func finishWorkout() {
        guard !exercises.isEmpty else { return }
        
        let workoutExercises = exercises.map { exercise in
            Workout.WorkoutExercise(
                name: exercise.name,
                sets: exercise.sets.map { set in
                    Workout.ExerciseSet(
                        weight: set.weight,
                        reps: set.reps,
                        isWarmup: false,
                        rpe: nil
                    )
                },
                notes: nil
            )
        }
        
        let totalVolume = exercises.reduce(0) { partialResult, exercise in
            partialResult + exercise.sets.reduce(0) { setResult, set in
                setResult + (set.weight * Double(set.reps))
            }
        }
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        completedWorkout = Workout(
            userId: userId,
            title: "Workout",
            description: "",
            exercises: workoutExercises,
            duration: elapsedTime,
            startTime: startTime,
            endTime: Date(),
            totalVolume: totalVolume
        )
        
        showWorkoutComplete = true
    }
    
    deinit {
        timer?.invalidate()
    }
}

// Models for active workout
struct ActiveExercise: Identifiable {
    let id = UUID()
    let name: String
    var sets: [ExerciseSet]
    let restSeconds: Int
}

struct ExerciseSet: Identifiable {
    let id = UUID()
    var weight: Double
    var reps: Int
    var isComplete = false
    var setNumber: Int = 1
    var isWarmup = false
    var rpe: Int?
} 