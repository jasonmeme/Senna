import SwiftUI
import FirebaseFirestore
import FirebaseAuth

@MainActor
class WorkoutViewModel: ObservableObject {
    @Published private(set) var workout: Workout
    @Published private(set) var elapsedTime: TimeInterval = 0
    @Published var isTimerRunning = false
    @Published var exercises: [WorkoutExercise]
    
    // Add completion-specific published properties
    @Published var rating: Int?
    @Published var notes: String?
    @Published var location: String?
    
    private var timer: Timer?
    private let db = Firestore.firestore()
    private let authManager = AuthenticationManager.shared
    
    init(template: Workout? = nil) {
        if let template = template {
            // Create active workout from template
            let activeExercises = template.exercises.map { exercise in
                var exercise = exercise
                exercise.state = .active
                return exercise
            }
            
            self.workout = Workout(
                id: UUID().uuidString,
                name: template.name,
                exercises: activeExercises,
                startTime: Date(),
                state: .active
            )
            self.exercises = activeExercises
        } else {
            // Create new empty workout
            self.workout = Workout(
                id: UUID().uuidString,
                name: "Quick Workout",
                exercises: [],
                startTime: Date(),
                state: .active
            )
            self.exercises = []
        }
    }
    
    // MARK: - Timer Management
    
    nonisolated private func createTimer() -> Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.elapsedTime += 1
            }
        }
    }
    
    func startTimer() {
        guard timer == nil else { return }
        timer = createTimer()
        isTimerRunning = true
    }
    
    func pauseTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
    }
    
    // MARK: - Exercise Management
    
    func addExercise(_ exercise: Exercise) {
        let workoutExercise = WorkoutExercise(from: exercise)
        exercises.append(workoutExercise)
        syncExercises()
    }
    
    func addTemplateExercise(_ templateExercise: TemplateExercise) {
        let workoutExercise = WorkoutExercise(from: templateExercise.exercise)
        exercises.append(workoutExercise)
        syncExercises()
    }
    
    func removeExercise(at index: Int) {
        exercises.remove(at: index)
        syncExercises()
    }
    
    func moveExercise(from source: IndexSet, to destination: Int) {
        exercises.move(fromOffsets: source, toOffset: destination)
        syncExercises()
    }
    
    private func syncExercises() {
        workout.exercises = exercises
    }
    
    // MARK: - Workout Completion
    
    func updateWorkoutCompletion(rating: Int?, notes: String?, location: String?) {
        self.rating = rating
        self.notes = notes
        self.location = location
    }
    
    func completeWorkout() {
        pauseTimer()
        workout.state = .completed
        workout.endTime = Date()
        workout.duration = elapsedTime
        workout.rating = rating
        workout.notes = notes
        workout.location = location
    }
    
    func saveWorkout() async throws {
        guard workout.state == .completed else { return }
        
        guard let user = try? authManager.getUser() else {
            throw AuthenticationError.notAuthenticated
        }
        
        workout.creatorId = user.uid
        
        let docRef = db.collection("workouts").document(workout.id)
        try await docRef.setData(workout.asDictionary())
    }
    
    deinit {
        timer?.invalidate()
    }
} 