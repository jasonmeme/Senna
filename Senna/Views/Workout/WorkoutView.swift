import SwiftUI
import FirebaseFirestore

struct WorkoutView: View {
    @StateObject var viewModel: WorkoutViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showExerciseSearch = false
    @State private var showCompletionSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.spacing) {
                    // Timer Card
                    timerCard
                    
                    // Exercises
                    exercisesList
                    
                    // Add Exercise Button
                    addExerciseButton
                }
                .padding()
            }
            .navigationTitle("Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Complete") {
                        viewModel.completeWorkout()
                        showCompletionSheet = true
                    }
                }
            }
        }
        .sheet(isPresented: $showExerciseSearch) {
            ExerciseSearchView { exercise in
                viewModel.addExercise(exercise)
            }
        }
        .sheet(isPresented: $showCompletionSheet) {
            WorkoutCompletionView(viewModel: viewModel)
        }
    }
    
    private var timerCard: some View {
        VStack {
            WorkoutTimerView(elapsedTime: viewModel.elapsedTime)
            
            Button {
                if viewModel.isTimerRunning {
                    viewModel.pauseTimer()
                } else {
                    viewModel.startTimer()
                }
            } label: {
                Label(
                    viewModel.isTimerRunning ? "Pause" : "Start",
                    systemImage: viewModel.isTimerRunning ? "pause.fill" : "play.fill"
                )
                .frame(maxWidth: .infinity)
                .primaryButtonStyle()
            }
        }
        .cardStyle()
    }
    
    private var exercisesList: some View {
        LazyVStack(spacing: Theme.spacing) {
            ForEach(viewModel.exercises.indices, id: \.self) { index in
                ExerciseCard(
                    exercise: $viewModel.exercises[index],
                    onDelete: {
                        viewModel.removeExercise(at: index)
                    }
                )
            }
        }
    }
    
    private var addExerciseButton: some View {
        Button {
            showExerciseSearch = true
        } label: {
            Label("Add Exercise", systemImage: "plus.circle.fill")
                .frame(maxWidth: .infinity)
                .secondaryButtonStyle()
        }
    }
} 