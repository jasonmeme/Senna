import SwiftUI
import PhotosUI

struct CreateWorkoutView: View {
    @StateObject private var viewModel = CreateWorkoutViewModel()
    @State private var showNewWorkout = false
    @State private var showNewTemplate = false
    @State private var selectedWorkout: Workout?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.spacing * 2) {
                    // Quick Start Section
                    quickStartSection
                    
                    // Templates Section
                    templatesSection
                }
                .padding(.vertical)
            }
            .navigationTitle("Workout")
            .refreshable {
                await viewModel.loadTemplates()
            }
        }
        .fullScreenCover(item: $selectedWorkout) { template in
            WorkoutView(viewModel: WorkoutViewModel(template: template))
        }
        .sheet(isPresented: $showNewTemplate) {
            TemplateDetailView(template: nil)
        }
    }
    
    private var quickStartSection: some View {
        VStack(alignment: .leading, spacing: Theme.spacing) {
            Text("Quick Start")
                .font(.title2)
                .fontWeight(.bold)
            
            Button {
                selectedWorkout = Workout(
                    id: UUID().uuidString,
                    name: "Quick Workout",
                    exercises: [],
                    state: .active
                )
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Empty Workout")
                            .font(.headline)
                        Text("Start with a blank workout")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
                .padding()
                .background(Theme.secondaryBackgroundColor)
                .cornerRadius(Theme.cornerRadius)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal)
    }
    
    private var templatesSection: some View {
        VStack(alignment: .leading, spacing: Theme.spacing) {
            HStack {
                Text("My Templates")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button {
                    showNewTemplate = true
                } label: {
                    Label("New Template", systemImage: "plus.circle.fill")
                        .foregroundColor(Theme.accentColor)
                }
            }
            
            if viewModel.templates.isEmpty {
                EmptyTemplatesView()
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: Theme.spacing),
                    GridItem(.flexible(), spacing: Theme.spacing)
                ], spacing: Theme.spacing) {
                    ForEach(viewModel.templates) { template in
                        TemplateCard(workout: template) {
                            selectedWorkout = template
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

