import SwiftUI

struct ActiveWorkoutView: View {
    let template: WorkoutTemplate?
    @StateObject private var viewModel: ActiveWorkoutViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showEndWorkoutConfirmation = false
    @State private var showAddExercise = false
    
    init(template: WorkoutTemplate? = nil) {
        self.template = template
        _viewModel = StateObject(wrappedValue: ActiveWorkoutViewModel(template: template))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.spacing) {
                    // Workout Info Section
                    VStack(spacing: Theme.spacing/2) {
                        WorkoutTimerView(elapsedTime: viewModel.elapsedTime)
                            .padding(.vertical, Theme.spacing/2)
                        
                        Divider()
                            .padding(.horizontal)
                        
                        // Stats Row (you can add more workout stats here)
                        HStack {
                            WorkoutStatView(title: "Exercises", value: "\(viewModel.exercises.count)")
                            Divider().frame(height: 20)
                            WorkoutStatView(title: "Total Sets", value: "\(viewModel.exercises.reduce(0) { $0 + $1.sets.count })")
                        }
                        .padding(.horizontal)
                        .padding(.bottom, Theme.spacing/2)
                    }
                    .background(Theme.secondaryBackgroundColor)
                    .cornerRadius(Theme.cornerRadius)
                    
                    // Exercises List
                    LazyVStack(spacing: Theme.spacing) {
                        ForEach($viewModel.exercises) { $exercise in
                            ActiveExerciseCard(exercise: $exercise)
                        }
                    }
                    
                    // Add Exercise Button
                    Button {
                        showAddExercise = true
                    } label: {
                        Label("Add Exercise", systemImage: "plus.circle.fill")
                            .font(.headline)
                            .foregroundColor(.accentColor)
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
                    Button(role: .destructive) {
                        showEndWorkoutConfirmation = true
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.red)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        finishWorkout()
                    } label: {
                        Text("Finish")
                            .fontWeight(.semibold)
                    }
                }
            }
            .sheet(isPresented: $showAddExercise) {
                ExerciseSearchView { exercise in
                    // TODO: Add exercise to workout
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

// Helper Views
struct WorkoutStatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
