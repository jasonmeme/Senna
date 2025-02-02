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
            ExerciseHeader(exercise: viewModel.exercise, onDelete: onDelete)
            
            Divider()
            
            // Sets
            VStack(spacing: Theme.spacing/2) {
                ForEach(Array(viewModel.sets.enumerated()), id: \.element.id) { index, set in
                    VStack(spacing: 4) {
                        SetRow(
                            index: index,
                            weight: Binding(
                                get: { String(set.weight ?? 0) },
                                set: { viewModel.updateWeight(at: index, text: $0) }
                            ),
                            reps: Binding(
                                get: { set.reps },
                                set: { viewModel.updateReps(at: index, reps: $0) }
                            )
                        )
                        
                        if index < viewModel.sets.count - 1 {
                            Divider()
                                .padding(.leading, Theme.spacing)
                        }
                    }
                }
            }
            .padding(.vertical, Theme.spacing/2)
            
            AddSetButton(action: viewModel.addSet)
            
            Divider()
            
            ExerciseFooter(exercise: viewModel.exercise)
        }
        .padding()
        .background(Theme.secondaryBackgroundColor)
        .cornerRadius(Theme.cornerRadius)
    }
}
