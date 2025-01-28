import SwiftUI

struct StrengthWorkoutView: View {
    @StateObject private var viewModel: StrengthWorkoutViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(template: WorkoutTemplate? = nil) {
        _viewModel = StateObject(wrappedValue: StrengthWorkoutViewModel(template: template))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Timer and Controls
//            WorkoutHeaderView(
//                elapsedTime: viewModel.elapsedTime,
//                onFinish: { viewModel.finishWorkout() },
//                onCancel: { viewModel.showCancelAlert = true }
//            )
            
            // Exercise List
            ScrollView {
                LazyVStack(spacing: Theme.spacing) {
                    ForEach($viewModel.exercises) { $exercise in
                        ExerciseSetGroupView(exercise: $exercise) { set in
                            viewModel.startRestTimer(after: set)
                        }
                    }
                    
                    // Add Exercise Button
                    Button {
                        viewModel.showExerciseSearch = true
                    } label: {
                        Label("Add Exercise", systemImage: "plus.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.secondaryBackgroundColor)
                            .cornerRadius(Theme.cornerRadius)
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $viewModel.showExerciseSearch) {
            ExerciseSearchView { exercise in
                viewModel.addExercise(exercise)
            }
        }
        .sheet(item: $viewModel.activeRestTimer) { timer in
            RestTimerView(duration: timer.duration)
        }
        .sheet(item: $viewModel.completedWorkout) { workout in
            WorkoutSummaryView(workout: workout)
        }
        .alert("Cancel Workout?", isPresented: $viewModel.showCancelAlert) {
            Button("Cancel Workout", role: .destructive) {
                dismiss()
            }
            Button("Continue", role: .cancel) { }
        }
    }
}

struct ExerciseSetGroupView: View {
    @Binding var exercise: ActiveExercise
    let onSetComplete: (ExerciseSet) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing) {
            // Exercise Header
            HStack {
                Text(exercise.name)
                    .font(.headline)
                Spacer()
                Button {
                    exercise.sets.append(ExerciseSet(weight: exercise.sets.last?.weight ?? 0,
                                                   reps: exercise.sets.last?.reps ?? 0))
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
            
            // Sets
            ForEach($exercise.sets) { $set in
                SetRowView(set: $set, onComplete: {
                    onSetComplete(set)
                })
            }
        }
        .padding()
        .background(Theme.secondaryBackgroundColor)
        .cornerRadius(Theme.cornerRadius)
    }
} 
