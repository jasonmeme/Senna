import SwiftUI

struct ExerciseCard: View {
    @StateObject private var viewModel: ExerciseCardViewModel
    let onDelete: () -> Void
    
    init(exercise: ViewTemplateExercise, onDelete: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: ExerciseCardViewModel(exercise: exercise))
        self.onDelete = onDelete
    }
    
    var body: some View {
        VStack(spacing: Theme.spacing) {
            // Exercise Title
            HStack {
                Image(systemName: viewModel.exercise.category.icon)
                    .foregroundStyle(Theme.accentColor)
                Text(viewModel.exercise.name)
                    .font(.headline)
                
                Spacer()
                
                Button(role: .destructive, action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
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
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.horizontal)
            
            // Sets
            ForEach(viewModel.sets.indices, id: \.self) { index in
                let set = viewModel.sets[index]
                SetRow(
                    index: index,
                    weight: Binding(
                        get: { String(format: "%.1f", set.weight ?? 0) },
                        set: { viewModel.updateWeight(at: index, text: $0) }
                    ),
                    reps: Binding(
                        get: { String(set.reps) },
                        set: { if let value = Int($0) { viewModel.updateReps(at: index, reps: value) } }
                    ),
                    isCompleted: Binding(
                        get: { set.isCompleted },
                        set: { viewModel.updateCompletion(at: index, isCompleted: $0) }
                    ),
                    onDelete: { viewModel.removeSet(at: index) }
                )
                
                if index < viewModel.sets.count - 1 {
                    Divider()
                }
            }
            
            // Add Set Button
            Button {
                viewModel.addSet()
            } label: {
                Label("Add Set", systemImage: "plus.circle.fill")
                    .font(.subheadline)
                    .foregroundColor(Theme.accentColor)
            }
            .padding(.top, 4)
            
            // Exercise Info Footer
            HStack {
                Label("\(viewModel.exercise.restSeconds)s", systemImage: "timer")
                Spacer()
                Label(viewModel.exercise.equipment, systemImage: "dumbbell.fill")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(Theme.secondaryBackgroundColor)
        .cornerRadius(Theme.cornerRadius)
    }
}
