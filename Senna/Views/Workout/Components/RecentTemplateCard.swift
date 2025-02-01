import SwiftUI

struct RecentTemplateCard: View {
    let template: WorkoutTemplate
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Theme.spacing/2) {
                Text(template.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text("\(template.exercises.count) exercises")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 200)
            .padding()
            .background(Theme.secondaryBackgroundColor)
            .cornerRadius(Theme.cornerRadius)
        }
        .buttonStyle(.plain)
    }
} 