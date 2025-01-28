import SwiftUI

struct RecentWorkoutsSection: View {
    let workouts: [Workout]
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing) {
            Text("Recent Workouts")
                .font(.headline)
            
            if workouts.isEmpty {
                Text("No recent workouts")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(workouts) { workout in
                    WorkoutCard(workout: workout)
                }
            }
        }
    }
}

struct MyTemplatesSection: View {
    let templates: [WorkoutTemplate]
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing) {
            Text("My Templates")
                .font(.headline)
            
            if templates.isEmpty {
                Text("No templates yet")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(templates) { template in
                    TemplateCard(template: template)
                }
            }
        }
    }
}

struct BrowseTemplatesSection: View {
    let templates: [WorkoutTemplate]
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing) {
            Text("Browse Templates")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Theme.spacing) {
                    ForEach(templates) { template in
                        TemplateCard(template: template)
                            .frame(width: 250)
                    }
                }
            }
        }
    }
}

private struct TemplateCard: View {
    let template: WorkoutTemplate
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing) {
            Text(template.name)
                .font(.headline)
            
            Text("\(template.exercises.count) exercises")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            HStack {
                Label("\(template.saveCount)", systemImage: "bookmark.fill")
                Label("\(template.usageCount)", systemImage: "figure.run")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(Theme.secondaryBackgroundColor)
        .cornerRadius(Theme.cornerRadius)
    }
} 