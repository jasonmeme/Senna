import SwiftUI

struct TemplateDetailView: View {
    let template: WorkoutTemplate
    @State private var exercises: [ViewTemplateExercise]
    @State private var showAddExercise = false
    @State private var templateName: String
    @State private var templateDescription: String
    @State private var isEditing = false
    
    init(template: WorkoutTemplate) {
        self.template = template
        // Convert template exercises to ViewTemplateExercise format
        _exercises = State(initialValue: template.exercises.map { exercise in
            ViewTemplateExercise(exercise: exercise)
        })
        _templateName = State(initialValue: template.name)
        _templateDescription = State(initialValue: template.description)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.spacing) {
                // Template Info
                VStack(alignment: .leading, spacing: Theme.spacing/2) {
                    if isEditing {
                        TextField("Template Name", text: $templateName)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        TextField("Description", text: $templateDescription)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        Text(templateName)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(templateDescription)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
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
                Button(isEditing ? "Done" : "Edit") {
                    withAnimation {
                        isEditing.toggle()
                    }
                }
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
        // Here you would save the updated template name and description as well
    }
} 