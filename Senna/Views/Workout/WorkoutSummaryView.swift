import SwiftUI

struct WorkoutSummaryView: View {
    let workout: Workout
    @Environment(\.dismiss) private var dismiss
    @State private var showShareSheet = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.spacing * 2) {
                    // Stats Summary
                    HStack(spacing: Theme.spacing * 2) {
                        StatBox(title: "Duration", value: workout.duration.formattedTime)
                        StatBox(title: "Volume", value: "\(Int(workout.totalVolume))kg")
                    }
                    
                    // Exercise List
                    VStack(alignment: .leading, spacing: Theme.spacing) {
                        Text("Exercises")
                            .font(.headline)
                        
                        ForEach(workout.exercises, id: \.name) { exercise in
                            ExerciseSummaryRow(exercise: exercise)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Workout Complete")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showShareSheet = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
    }
}

private struct StatBox: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Theme.secondaryBackgroundColor)
        .cornerRadius(Theme.cornerRadius)
    }
}

private struct ExerciseSummaryRow: View {
    let exercise: Workout.WorkoutExercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(exercise.name)
                .font(.headline)
            
            Text("\(exercise.sets.count) sets • \(totalReps) reps • \(Int(totalVolume))kg")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.secondaryBackgroundColor)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private var totalReps: Int {
        exercise.sets.reduce(0) { $0 + $1.reps }
    }
    
    private var totalVolume: Double {
        exercise.sets.reduce(0) { $0 + ($1.weight * Double($1.reps)) }
    }
} 