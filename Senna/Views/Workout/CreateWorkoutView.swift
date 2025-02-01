import SwiftUI
import PhotosUI

struct CreateWorkoutView: View {
    @StateObject private var viewModel = CreateWorkoutViewModel()
    @State private var showActiveWorkout = false
    @State private var selectedTemplate: WorkoutTemplate?
    @State private var showNewTemplate = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.spacing * 3) {
                    // Quick Start Section
                    VStack(spacing: Theme.spacing) {
                        Text("Quick Start")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button {
                            selectedTemplate = nil
                            showActiveWorkout = true
                        } label: {
                            HStack(spacing: Theme.spacing) {
                                Image(systemName: "play.circle.fill")
                                    .font(.title2)
                                VStack(alignment: .leading) {
                                    Text("Start Empty Workout")
                                        .font(.headline)
                                    Text("Create a workout from scratch")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Theme.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(Theme.cornerRadius)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Recent Templates Section
                    if !viewModel.recentTemplates.isEmpty {
                        VStack(alignment: .leading, spacing: Theme.spacing) {
                            Text("Recent")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: Theme.spacing) {
                                    ForEach(viewModel.recentTemplates.prefix(3)) { template in
                                        RecentTemplateCard(template: template) {
                                            selectedTemplate = template
                                            showActiveWorkout = true
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // All Templates Section
                    VStack(alignment: .leading, spacing: Theme.spacing) {
                        HStack {
                            Text("My Templates")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            NavigationLink {
                                TemplateDetailView(template: viewModel.createNewTemplate())
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
                                    TemplateCard(template: template) {
                                        selectedTemplate = template
                                        showActiveWorkout = true
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Workout")
            .fullScreenCover(isPresented: $showActiveWorkout) {
                VStack {
                    Text("Fake Active Workout View")
                    Text("Template Name: Test")
                }
            }
        }
    }
}

