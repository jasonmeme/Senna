import SwiftUI

struct TemplateCard: View {
    let template: WorkoutTemplate
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Theme.spacing) {
                // Template Name
                Text(template.name)
                    .font(.headline)
                    .lineLimit(1)
                
                // Description if exists
                if !template.description.isEmpty {
                    Text(template.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                
                // Exercise Preview
                ForEach(template.exercises.prefix(2), id: \.name) { exercise in
                    HStack(spacing: Theme.spacing/2) {
                        Image(systemName: exercise.category.icon)
                            .foregroundStyle(Theme.accentColor)
                        Text(exercise.name)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .lineLimit(1)
                }
                
                if template.exercises.count > 2 {
                    Text("+ \(template.exercises.count - 2) more")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                // Last Updated
                Text(template.updatedAt.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.secondaryBackgroundColor)
            .cornerRadius(Theme.cornerRadius)
        }
        .buttonStyle(.plain)
    }
} 