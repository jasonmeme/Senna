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
            
            // Sets
            VStack(spacing: Theme.spacing/2) {
                ForEach(0..<exercise.sets, id: \.self) { index in
                    HStack {
                        Text("Set \(index + 1)")
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text("lbs") // This will be dynamic once we add weight tracking
                            .foregroundStyle(Theme.accentColor)
                        
                        Text("×")
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 4)
                        
                        Text("\(exercise.reps) reps")
                    }
                    .font(.subheadline)
                    
                    if index < exercise.sets - 1 {
                        Divider()
                            .padding(.leading, Theme.spacing)
                    }
                }
            }
            .padding(.vertical, Theme.spacing/2)
            
            // Footer info
            HStack {
                Label {
                    Text("\(exercise.restSeconds)s rest")
                } icon: {
                    Image(systemName: "timer")
                }
                
                Spacer()
                
                Label {
                    Text(exercise.equipment)
                } icon: {
                    Image(systemName: "dumbbell.fill")
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            
            // Notes if any
            if let notes = exercise.notes {
                Divider()
                HStack {
                    Image(systemName: "note.text")
                    Text(notes)
                    Spacer()
                }
                .font(.caption)
                .foregroundStyle(.secondary)
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