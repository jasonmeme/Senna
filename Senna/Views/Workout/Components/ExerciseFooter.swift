import SwiftUI

struct ExerciseFooter: View {
    let exercise: ViewTemplateExercise
    
    var body: some View {
        VStack(spacing: Theme.spacing) {
            HStack {
                Label {
                    Text("\(exercise.restSeconds)s rest")
                } icon: {
                    Image(systemName: "timer")
                }
                
                Spacer()
                
                Label {
                    Text(exercise.equipment)
                } icon: {
                    Image(systemName: "dumbbell.fill")
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            
            if let notes = exercise.notes {
                Divider()
                HStack {
                    Image(systemName: "note.text")
                    Text(notes)
                    Spacer()
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
    }
} 