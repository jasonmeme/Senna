import SwiftUI

struct TemplateDetailView: View {
    let template: WorkoutTemplate
    @State private var exercises: [ViewTemplateExercise]
    @State private var showAddExercise = false
    
    init(template: WorkoutTemplate) {
        self.template = template
        // Convert template exercises to ViewTemplateExercise format
        _exercises = State(initialValue: template.exercises.map { exercise in
            ViewTemplateExercise(exercise: exercise)
        })
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.spacing) {
                // Template Info
                VStack(alignment: .leading, spacing: Theme.spacing/2) {
                    Text(template.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(template.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Theme.secondaryBackgroundColor)
                .cornerRadius(Theme.cornerRadius)
                
                // Exercises List
                LazyVStack(spacing: Theme.spacing) {
                    ForEach(exercises) { exercise in
                        ExerciseCard(exercise: exercise) {
                            if let index = exercises.firstIndex(where: { $0.id == exercise.id }) {
                                exercises.remove(at: index)
                            }
                        }
                    }
                    .onMove { from, to in
                        exercises.move(fromOffsets: from, toOffset: to)
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
                let templateExercise = TemplateExercise(from: exercise)
                exercises.append(ViewTemplateExercise(exercise: templateExercise))
            }
        }
    }
    
    private func saveTemplate() {
        // Convert ViewTemplateExercise back to TemplateExercise when saving
        let templateExercises = exercises.map { $0.exercise }
        // Save template changes using templateExercises
    }
} 