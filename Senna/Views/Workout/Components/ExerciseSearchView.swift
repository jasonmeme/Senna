import SwiftUI
import FirebaseFirestore

struct ExerciseSearchView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ExerciseSearchViewModel()
    let onExerciseSelected: (Exercise) -> Void
    
    var body: some View {
        NavigationStack {
            List {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if viewModel.exercises.isEmpty {
                    Text("No exercises found")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.filteredExercises) { exercise in
                        ExerciseRow(exercise: exercise)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                onExerciseSelected(exercise)
                                dismiss()
                            }
                    }
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search exercises")
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ExerciseRow: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing/2) {
            HStack {
                Image(systemName: exercise.category.icon)
                    .foregroundStyle(Theme.accentColor)
                Text(exercise.name)
                    .font(.headline)
            }
            
            if !exercise.muscles.isEmpty {
                Text(exercise.muscles.joined(separator: ", "))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            if !exercise.equipment.isEmpty {
                Text(exercise.equipment.joined(separator: ", "))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
} 
