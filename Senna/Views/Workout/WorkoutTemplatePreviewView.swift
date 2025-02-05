import SwiftUI

struct WorkoutTemplatePreviewView: View {
    let workout: Workout
    @State private var showActiveWorkout = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.spacing) {
                // Template Info
                VStack(alignment: .leading, spacing: Theme.spacing/2) {
                    Text(workout.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if let description = workout.description {
                        Text(description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .cardStyle()
                
                // Exercise Preview List
                LazyVStack(spacing: Theme.spacing) {
                    ForEach(workout.exercises) { exercise in
                        ExerciseCard(
                            exercise: .constant(exercise),
                            onDelete: nil
                        )
                    }
                }
                
                // Start Workout Button
                Button {
                    showActiveWorkout = true
                } label: {
                    Label("Start Workout", systemImage: "play.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .primaryButtonStyle()
                }
            }
            .padding()
        }
        .navigationTitle("Workout Preview")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showActiveWorkout) {
            WorkoutView(viewModel: WorkoutViewModel(template: workout))
        }
    }
}

struct ExercisePreviewRow: View {
    let exercise: TemplateExercise
    
    var body: some View {
        HStack {
            Text(exercise.name)
                .font(.body)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Theme.secondaryBackgroundColor)
        .cornerRadius(Theme.cornerRadius)
    }
} 
