import SwiftUI

struct TemplateDetailView: View {
    @StateObject private var viewModel: TemplateViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showExerciseSearch = false
    @State private var showingError = false
    
    init(template: Workout?) {
        _viewModel = StateObject(wrappedValue: TemplateViewModel(template: template))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.spacing) {
                    // Template Info
                    templateInfoSection
                    
                    // Exercises
                    exercisesSection
                    
                    // Add Exercise Button
                    addExerciseButton
                }
                .padding()
            }
            .navigationTitle(viewModel.template.name.isEmpty ? "New Template" : viewModel.template.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            do {
                                try await viewModel.saveTemplate()
                                dismiss()
                            } catch {
                                showingError = true
                            }
                        }
                    }
                    .disabled(!viewModel.isValid)
                }
            }
        }
        .sheet(isPresented: $showExerciseSearch) {
            ExerciseSearchView { exercise in
                viewModel.addExercise(exercise)
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Failed to save template. Please try again.")
        }
    }
    
    private var templateInfoSection: some View {
        VStack(alignment: .leading, spacing: Theme.spacing) {
            TextField("Template Name", text: $viewModel.template.name)
                .font(.title2)
                .textFieldStyle(.roundedBorder)
            
            TextField("Description (Optional)", text: Binding(
                get: { viewModel.template.notes ?? "" },
                set: { viewModel.template.notes = $0.isEmpty ? nil : $0 }
            ))
            .textFieldStyle(.roundedBorder)
        }
    }
    
    private var exercisesSection: some View {
        LazyVStack(spacing: Theme.spacing) {
            ForEach($viewModel.template.exercises) { $exercise in
                ExerciseCard(
                    exercise: $exercise,
                    onDelete: {
                        if let index = viewModel.template.exercises.firstIndex(where: { $0.id == exercise.id }) {
                            viewModel.removeExercise(at: index)
                        }
                    }
                )
            }
            .onMove { from, to in
                viewModel.moveExercise(from: from, to: to)
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