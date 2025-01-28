import SwiftUI
import PhotosUI

struct CreateWorkoutView: View {
    @StateObject private var viewModel = CreateWorkoutViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Button {
                        viewModel.showTemplateSelection = true
                    } label: {
                        if let template = viewModel.selectedTemplate {
                            Label("Using template: \(template.name)", systemImage: "doc.fill")
                        } else {
                            Label("Use Template", systemImage: "doc.badge.plus")
                        }
                    }
                    
                    TextField("Title", text: $viewModel.title)
                    TextField("Description", text: $viewModel.description, axis: .vertical)
                        .lineLimit(3...6)
                    
                    Picker("Type", selection: $viewModel.workoutType) {
                        ForEach(WorkoutType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                }
                
                Section("Exercises") {
                    ForEach(viewModel.exercises) { exercise in
                        Text(exercise.name)
                    }
                    
                    Button {
                        // Add exercise action
                    } label: {
                        Label("Add Exercise", systemImage: "plus.circle.fill")
                    }
                }
                
                Section {
                    PhotosPicker(selection: $viewModel.selectedItem,
                               matching: .images) {
                        if let selectedImage = viewModel.selectedImage {
                            selectedImage
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 200)
                        } else {
                            Label("Add Photo", systemImage: "photo")
                        }
                    }
                }
                
                Section {
                    Toggle("Include Location", isOn: $viewModel.includeLocation)
                }
            }
            .navigationTitle("Create Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Create") {
                        Task {
                            await viewModel.createWorkout()
                            dismiss()
                        }
                    }
                    .disabled(!viewModel.isValid)
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.error?.localizedDescription ?? "Unknown error occurred")
            }
            .task {
                if let selectedItem = viewModel.selectedItem {
                    await viewModel.loadImage()
                }
            }
            .sheet(isPresented: $viewModel.showTemplateSelection) {
                TemplateSelectionView(onSelect: { template in
                    viewModel.selectedTemplate = template
                    viewModel.applyTemplate(template)
                })
            }
        }
    }
}