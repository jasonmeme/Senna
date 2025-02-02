import SwiftUI

struct TemplateDetailView: View {
    let template: WorkoutTemplate
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: TemplateDetailViewModel
    @State private var showAddExercise = false
    
    init(template: WorkoutTemplate) {
        self.template = template
        _viewModel = StateObject(wrappedValue: TemplateDetailViewModel(template: template))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.spacing) {
                // Template Info
                VStack(alignment: .leading, spacing: Theme.spacing/2) {
                    TextField("Template Name", text: $viewModel.templateName)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    TextField("Add a description (optional)", text: $viewModel.templateDescription)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Theme.secondaryBackgroundColor)
                .cornerRadius(Theme.cornerRadius)
                
                // Exercises List
                LazyVStack(spacing: Theme.spacing) {
                    ForEach(viewModel.exercises) { exercise in
                        ExerciseCard(exercise: exercise) {
                            if let index = viewModel.exercises.firstIndex(where: { $0.id == exercise.id }) {
                                viewModel.removeExercise(at: index)
                            }
                        }
                    }
                    .onMove { from, to in
                        viewModel.moveExercise(from: from, to: to)
                    }
                }
                
                // Add Exercise Button
                Button {
                    showAddExercise = true
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
        .navigationTitle("Template Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save", action: saveTemplate)
            }
        }
        .sheet(isPresented: $showAddExercise) {
            ExerciseSearchView { exercise in
                viewModel.addExercise(exercise)
            }
        }
    }
    
    private func saveTemplate() {
        Task {
            do {
                try await viewModel.saveTemplate()
                dismiss()
            } catch {
                print("Error saving template: \(error)")
            }
        }
    }
} 