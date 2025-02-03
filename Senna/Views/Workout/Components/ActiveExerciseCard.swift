import SwiftUI

struct ActiveExerciseCard: View {
    @Binding var exercise: ActiveExercise
    
    var body: some View {
        VStack(spacing: Theme.spacing/2) {
            // Exercise Header
            HStack {
                Image(systemName: "figure.strengthtraining.traditional") // TODO: Add category icon
                    .foregroundStyle(Theme.accentColor)
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
            
            Divider()
            
            // Column Headers
            HStack(spacing: 12) {
                Text("SET")
                    .frame(width: 40, alignment: .leading)
                Text("LBS")
                    .frame(width: 70, alignment: .center)
                Text("REPS")
                    .frame(width: 70, alignment: .center)
                Spacer()
                Text("DONE")
                    .frame(width: 50, alignment: .center)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.horizontal)
            
            // Sets
            ForEach(Array(exercise.sets.enumerated()), id: \.element.id) { index, _ in
                ActiveSetRow(index: index, set: $exercise.sets[index])
                if index < exercise.sets.count - 1 {
                    Divider()
                }
            }
            
            // Add Set Button
            Button {
                exercise.sets.append(SetData(
                    reps: exercise.sets.last?.reps ?? ExerciseConstants.defaultReps
                ))
            } label: {
                Label("Add Set", systemImage: "plus.circle.fill")
                    .font(.subheadline)
                    .foregroundColor(Theme.accentColor)
            }
            .padding(.top, 4)
            
            // Exercise Info Footer
            HStack {
                Label("60s", systemImage: "timer")
                Spacer()
                Label("Barbell", systemImage: "dumbbell.fill")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(Theme.secondaryBackgroundColor)
        .cornerRadius(Theme.cornerRadius)
    }
} 