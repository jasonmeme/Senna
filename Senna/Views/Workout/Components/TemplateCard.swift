import SwiftUI

struct TemplateCard: View {
    let template: WorkoutTemplate
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Theme.spacing) {
                HStack {
                    Text(template.name)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Menu {
                        NavigationLink("Edit") {
                            TemplateDetailView(template: template)
                        }
                        Button("Delete", role: .destructive, action: {})
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Preview first 2 exercises
                ForEach(template.exercises.prefix(2), id: \.name) { exercise in
                    Text(exercise.name)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                
                if template.exercises.count > 2 {
                    Text("+ \(template.exercises.count - 2) more")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Text(template.updatedAt.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .fill(Theme.secondaryBackgroundColor)
                    .shadow(color: .black.opacity(0.1), radius: 5)
            )
        }
        .buttonStyle(.plain)
    }
} 