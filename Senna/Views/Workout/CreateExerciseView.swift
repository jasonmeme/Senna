import SwiftUI

struct CreateExerciseView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var category = ExerciseCategory.other
    let onSave: (Exercise) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Exercise Name", text: $name)
                    
                    Picker("Category", selection: $category) {
                        ForEach(ExerciseCategory.allCases) { category in
                            Text(category.name).tag(category)
                        }
                    }
                }
            }
            .navigationTitle("Create Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let exercise = Exercise(
                            name: name,
                            category: category,
                            isCustom: true
                        )
                        onSave(exercise)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
} 