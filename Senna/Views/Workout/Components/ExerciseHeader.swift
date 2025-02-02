import SwiftUI

struct ExerciseHeader: View {
    let exercise: ViewTemplateExercise
    let onDelete: () -> Void
    
    var body: some View {
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
    }
} 