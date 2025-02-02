import SwiftUI

struct WorkoutTemplatePreviewView: View {
    let template: WorkoutTemplate
    @State private var showActiveWorkout = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.spacing) {
                // Template Info
                VStack(alignment: .leading, spacing: Theme.spacing/2) {
                    Text(template.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if !template.description.isEmpty {
                        Text(template.description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Theme.secondaryBackgroundColor)
                .cornerRadius(Theme.cornerRadius)
                
                // Exercise Preview List
                LazyVStack(spacing: Theme.spacing) {
                    ForEach(template.exercises) { exercise in
                        ExercisePreviewRow(exercise: exercise)
                    }
                }
                
                // Start Workout Button
                Button {
                    showActiveWorkout = true
                } label: {
                    Label("Start Workout", systemImage: "play.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(Theme.cornerRadius)
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Workout Preview")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showActiveWorkout) {
            ActiveWorkoutView(template: template)
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
