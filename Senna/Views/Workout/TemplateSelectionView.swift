import SwiftUI

struct TemplateSelectionView: View {
    @StateObject private var viewModel = WorkoutTemplatesViewModel()
    @Environment(\.dismiss) private var dismiss
    let onSelect: ((WorkoutTemplate) -> Void)?
    
    init(onSelect: ((WorkoutTemplate) -> Void)? = nil) {
        self.onSelect = onSelect
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.spacing * 2) {
                    // My Templates Section
                    VStack(alignment: .leading, spacing: Theme.spacing) {
                        Text("My Templates")
                            .font(.headline)
                        
                        ForEach(viewModel.userTemplates) { template in
                            TemplateCardView(template: template) {
                                onSelect?(template)
                                dismiss()
                            }
                        }
                        
                        if viewModel.userTemplates.isEmpty {
                            Text("No templates yet")
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    // Popular Templates Section
                    VStack(alignment: .leading, spacing: Theme.spacing) {
                        Text("Popular Templates")
                            .font(.headline)
                        
                        ForEach(viewModel.popularTemplates) { template in
                            TemplateCardView(template: template) {
                                onSelect?(template)
                                dismiss()
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Templates")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .task {
                await viewModel.loadTemplates()
            }
        }
    }
}

struct TemplateCardView: View {
    let template: WorkoutTemplate
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
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
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Theme.secondaryBackgroundColor)
            .cornerRadius(Theme.cornerRadius)
        }
        .buttonStyle(.plain)
    }
} 