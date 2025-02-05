import SwiftUI

struct TemplateCard: View {
    let workout: Workout
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Theme.spacing) {
                // Template Name
                Text(workout.name)
                    .font(.headline)
                    .lineLimit(1)
                
                // Description if exists
                if let notes = workout.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                
                // Exercise Preview
                ForEach(workout.exercises.prefix(2)) { exercise in
                    HStack(spacing: Theme.spacing/2) {
                        Image(systemName: exercise.category.icon)
                            .foregroundStyle(Theme.accentColor)
                        Text(exercise.name)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .lineLimit(1)
                }
                
                if workout.exercises.count > 2 {
                    Text("+ \(workout.exercises.count - 2) more")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .cardStyle()
        }
        .buttonStyle(.plain)
    }
} 
