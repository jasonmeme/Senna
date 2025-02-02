import SwiftUI

struct ActiveExerciseCard: View {
    @Binding var exercise: ActiveExercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing) {
            // Exercise Header
            HStack {
                Text(exercise.name)
                    .font(.headline)
                Spacer()
                Menu {
                    Button(role: .destructive) {
                        // TODO: Remove exercise
                    } label: {
                        Label("Remove Exercise", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .padding(8)
                }
            }
            
            // Sets
            ForEach(Array(exercise.sets.enumerated()), id: \.element.id) { index, _ in
                ActiveSetRow(index: index, set: $exercise.sets[index])
            }
            
            // Add Set Button
            Button {
                exercise.sets.append(SetData(
                    reps: exercise.sets.last?.reps ?? ExerciseConstants.defaultReps
                ))
            } label: {
                Label("Add Set", systemImage: "plus")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
        }
        .padding()
        .background(Theme.secondaryBackgroundColor)
        .cornerRadius(Theme.cornerRadius)
    }
} 