import SwiftUI

struct ActiveWorkoutView: View {
    @StateObject private var viewModel = ActiveWorkoutViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Timer Header
                WorkoutTimerHeader(
                    duration: viewModel.elapsedTime,
                    isRunning: viewModel.isWorkoutActive
                )
                
                ScrollView {
                    LazyVStack(spacing: Theme.spacing) {
                        ForEach($viewModel.exercises) { $exercise in
                            ExerciseCard(exercise: $exercise)
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
            .navigationTitle("Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        viewModel.showCancelAlert = true
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.finishWorkout()
                    } label: {
                        Text("Finish")
                            .fontWeight(.semibold)
                    }
                    .disabled(viewModel.exercises.isEmpty)
                }
            }
            .sheet(isPresented: $viewModel.showExerciseSearch) {
                ExerciseSearchView(onSelect: viewModel.addExercise)
            }
            .alert("Cancel Workout?", isPresented: $viewModel.showCancelAlert) {
                Button("Cancel Workout", role: .destructive) {
                    dismiss()
                }
                Button("Continue Workout", role: .cancel) {}
            } message: {
                Text("Are you sure you want to cancel this workout? All progress will be lost.")
            }
            .sheet(isPresented: $viewModel.showWorkoutComplete) {
                WorkoutSummaryView(workout: viewModel.completedWorkout!)
            }
        }
    }
}

// Timer Header Component
private struct WorkoutTimerHeader: View {
    let duration: TimeInterval
    let isRunning: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Text(duration.formattedTime)
                .font(.system(size: 44, weight: .semibold, design: .monospaced))
            
            Text(isRunning ? "Workout in Progress" : "Workout Paused")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
}

// Exercise Card Component
private struct ExerciseCard: View {
    @Binding var exercise: ActiveExercise
    @State private var showRestTimer = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing) {
            // Exercise Header
            HStack {
                Text(exercise.name)
                    .font(.headline)
                
                Spacer()
                
                Menu {
                    Button(role: .destructive) {
                        // Delete exercise
                    } label: {
                        Label("Delete Exercise", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .padding(8)
                }
            }
            
            // Sets
            ForEach($exercise.sets) { $set in
                SetRow(set: $set, onComplete: {
                    showRestTimer = true
                })
            }
            
            // Add Set Button
            Button {
                exercise.sets.append(ExerciseSet(weight: exercise.sets.last?.weight ?? 0,
                                               reps: exercise.sets.last?.reps ?? 0))
            } label: {
                Label("Add Set", systemImage: "plus")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 4)
        }
        .padding()
        .background(Theme.secondaryBackgroundColor)
        .cornerRadius(Theme.cornerRadius)
        .sheet(isPresented: $showRestTimer) {
            RestTimerView(duration: exercise.restSeconds)
        }
    }
}

// Set Row Component
private struct SetRow: View {
    @Binding var set: ExerciseSet
    let onComplete: () -> Void
    
    var body: some View {
        HStack(spacing: Theme.spacing) {
            // Set Number
            Text("\(set.setNumber)")
                .frame(width: 30)
                .foregroundStyle(.secondary)
            
            // Weight
            HStack {
                TextField("0", value: $set.weight, format: .number)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                Text("kg")
            }
            .frame(width: 80)
            
            // Reps
            HStack {
                TextField("0", value: $set.reps, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                Text("reps")
            }
            .frame(width: 80)
            
            // Complete Button
            Button {
                set.isComplete = true
                onComplete()
            } label: {
                Image(systemName: set.isComplete ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(set.isComplete ? .green : .secondary)
            }
        }
        .textFieldStyle(.roundedBorder)
    }
} 