import SwiftUI

struct ExerciseCard: View {
    let exercise: ViewTemplateExercise
    let onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: Theme.spacing) {
            // Header with name and menu
            HStack {
                HStack(spacing: Theme.spacing/2) {
                    Image(systemName: exercise.category.icon)
                        .foregroundStyle(Theme.accentColor)
                    Text(exercise.name)
                        .font(.headline)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Menu {
                    Button("Edit", action: {
                        // TODO: Implement edit functionality
                    })
                    Button("Delete", role: .destructive, action: onDelete)
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.secondary)
                }
            }
            
            Divider()
            
            // Exercise details
            HStack(spacing: Theme.spacing * 2) {
                // Sets and reps
                VStack(alignment: .leading) {
                    Label {
                        Text("\(exercise.sets) sets")
                    } icon: {
                        Image(systemName: "number.circle.fill")
                            .foregroundStyle(Theme.accentColor)
                    }
                    
                    Label {
                        Text("\(exercise.reps) reps")
                    } icon: {
                        Image(systemName: "repeat.circle.fill")
                            .foregroundStyle(Theme.accentColor)
                    }
                }
                
                Spacer()
                
                // Rest time and equipment
                VStack(alignment: .trailing) {
                    Label {
                        Text("\(exercise.restSeconds)s rest")
                    } icon: {
                        Image(systemName: "timer")
                            .foregroundStyle(Theme.accentColor)
                    }
                    
                    Label {
                        Text(exercise.equipment)
                            .lineLimit(1)
                    } icon: {
                        Image(systemName: "dumbbell.fill")
                            .foregroundStyle(Theme.accentColor)
                    }
                }
            }
            .font(.subheadline)
            
            // Notes if any
            if let notes = exercise.notes {
                HStack {
                    Image(systemName: "note.text")
                        .foregroundStyle(Theme.accentColor)
                    Text(notes)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
            
            // Muscles worked
            if !exercise.muscles.isEmpty {
                HStack {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .foregroundStyle(Theme.accentColor)
                    Text(exercise.muscles.joined(separator: ", "))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
        }
        .padding()
        .background(Theme.secondaryBackgroundColor)
        .cornerRadius(Theme.cornerRadius)
    }
}

#Preview {
    ExerciseCard(
        exercise: ViewTemplateExercise(
            exercise: TemplateExercise(
                name: "Bench Press",
                sets: 3,
                reps: 10,
                restSeconds: 60,
                notes: "Keep elbows tucked",
                category: .push,
                muscles: ["Chest", "Triceps", "Shoulders"],
                equipment: "Barbell"
            )
        )
    ) {
        print("Delete tapped")
    }
    .padding()
} 