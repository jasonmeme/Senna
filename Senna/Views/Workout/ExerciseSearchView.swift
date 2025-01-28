import SwiftUI

struct ExerciseSearchView: View {
    @StateObject private var viewModel = ExerciseSearchViewModel()
    @Environment(\.dismiss) private var dismiss
    let onSelect: (Exercise) -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                searchBar
                
                // Category Filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Theme.spacing) {
                        ForEach(ExerciseCategory.allCases) { category in
                            CategoryPill(
                                category: category,
                                isSelected: viewModel.selectedCategory == category
                            ) {
                                viewModel.selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
                
                // Exercise List
                List {
                    ForEach(viewModel.filteredExercises) { exercise in
                        ExerciseRow(exercise: exercise) {
                            onSelect(exercise)
                            dismiss()
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.showCreateExercise = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showCreateExercise) {
                CreateExerciseView { exercise in
                    viewModel.addCustomExercise(exercise)
                    onSelect(exercise)
                    dismiss()
                }
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            
            TextField("Search exercises", text: $viewModel.searchText)
                .textFieldStyle(.plain)
            
            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

// MARK: - Supporting Views
private struct CategoryPill: View {
    let category: ExerciseCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(category.name)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Theme.accentColor : Theme.secondaryBackgroundColor)
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }
}

private struct ExerciseRow: View {
    let exercise: Exercise
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack {
                VStack(alignment: .leading) {
                    Text(exercise.name)
                        .font(.headline)
                    
                    Text(exercise.category.name)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "plus.circle")
                    .foregroundStyle(Theme.accentColor)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
