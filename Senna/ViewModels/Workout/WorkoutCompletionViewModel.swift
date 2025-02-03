import SwiftUI
import PhotosUI

@MainActor
class WorkoutCompletionViewModel: ObservableObject {
    private let workout: ActiveWorkoutViewModel
    
    @Published var workoutTitle: String = ""
    @Published var notes: String = ""
    @Published var selectedPhotos: [PhotosPickerItem?] = [nil, nil, nil]
    @Published var imageStates: [Image?] = [nil, nil, nil]
    @Published var selectedMood: Int = 0
    @Published var location: String = ""
    @Published var friendTags: String = ""
    
    var exerciseCount: Int {
        workout.exercises.count
    }
    
    var totalSets: Int {
        workout.exercises.reduce(0) { $0 + $1.sets.count }
    }
    
    var formattedDuration: String {
        let duration = Int(workout.elapsedTime)
        let hours = duration / 3600
        let minutes = (duration % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    init(workout: ActiveWorkoutViewModel) {
        self.workout = workout
        self.workoutTitle = workout.template?.name ?? "Quick Workout"
    }
} 