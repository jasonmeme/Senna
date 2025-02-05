import SwiftUI

struct ExerciseCard: View {
    @Binding var exercise: WorkoutExercise
    let onDelete: (() -> Void)?
    
    var body: some View {
        VStack(spacing: Theme.spacing) {
            // Header
            exerciseHeader
            
            Divider()
            
            // Sets Section
            setsSection
            
            // Add Set Button (only for template/active)
            if exercise.state != .completed {
                addSetButton
            }
            
            // Footer Info
            exerciseFooter
        }
        .padding()
        .background(Theme.secondaryBackgroundColor)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private var exerciseHeader: some View {
        HStack {
            Image(systemName: exercise.category.icon)
                .foregroundStyle(Theme.accentColor)
            Text(exercise.name)
                .font(.headline)
            
            Spacer()
            
            if let onDelete = onDelete {
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    private var setsSection: some View {
        VStack(spacing: Theme.spacing/2) {
            // Column Headers
            HStack(spacing: 12) {
                Text("SET")
                    .frame(width: 40, alignment: .leading)
                Text("WEIGHT")
                    .frame(width: 70, alignment: .center)
                Text("REPS")
                    .frame(width: 70, alignment: .center)
                Spacer()
                if exercise.state == .active {
                    Text("DONE")
                        .frame(width: 50, alignment: .center)
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            
            // Sets
            ForEach(Array(exercise.sets.enumerated()), id: \.element.id) { index, _ in
                SetRow(
                    index: index,
                    set: $exercise.sets[index],
                    showCompletion: exercise.state == .active,
                    onDelete: {
                        exercise.sets.remove(at: index)
                    }
                )
                
                if index < exercise.sets.count - 1 {
                    Divider()
                }
            }
        }
    }
    
    private var addSetButton: some View {
        Button {
            exercise.sets.append(SetData())
        } label: {
            Label("Add Set", systemImage: "plus.circle.fill")
                .font(.subheadline)
                .foregroundColor(Theme.accentColor)
        }
        .padding(.top, 4)
    }
    
    private var exerciseFooter: some View {
        HStack {
            Label("\(exercise.restSeconds)s", systemImage: "timer")
            Spacer()
            Label(exercise.equipment[0], systemImage: "dumbbell.fill")
        }
        .font(.caption)
        .foregroundStyle(.secondary)
    }
}
