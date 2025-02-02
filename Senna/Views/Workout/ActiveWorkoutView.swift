import SwiftUI

struct ActiveWorkoutView: View {
    let template: WorkoutTemplate?  // Optional since it can be started from empty
    @StateObject private var viewModel: ActiveWorkoutViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showEndWorkoutConfirmation = false
    
    init(template: WorkoutTemplate? = nil) {
        self.template = template
        _viewModel = StateObject(wrappedValue: ActiveWorkoutViewModel(template: template))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.spacing) {
                    WorkoutTimerView(elapsedTime: viewModel.elapsedTime)
                        .padding(.vertical)
                    
                    LazyVStack(spacing: Theme.spacing) {
                        ForEach($viewModel.exercises) { $exercise in
                            ActiveExerciseCard(exercise: $exercise)
                        }
                    }
                    
                    Button {
                        // TODO: Show exercise search
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
            .navigationTitle("Active Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .destructive) {
                        showEndWorkoutConfirmation = true
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Finish", action: finishWorkout)
                }
            }
            .alert("End Workout?", isPresented: $showEndWorkoutConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("End Workout", role: .destructive) {
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to end this workout? All progress will be lost.")
            }
        }
    }
    
    private func finishWorkout() {
        // TODO: Save workout and show post-workout view
    }
}
