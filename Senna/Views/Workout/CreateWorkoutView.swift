import SwiftUI
import PhotosUI

struct CreateWorkoutView: View {
    @StateObject private var viewModel = CreateWorkoutViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                // Workout Type
                Section("Workout Type") {
                    Picker("Type", selection: $viewModel.workoutType) {
                        ForEach(WorkoutType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                }
                
                // Description
                Section("Description") {
                    TextEditor(text: $viewModel.description)
                        .frame(minHeight: 100)
                }
                
                // Photo
                Section("Photo") {
                    PhotosPicker(selection: $viewModel.selectedItem,
                               matching: .images) {
                        if let image = viewModel.selectedImage {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 200)
                        } else {
                            Label("Add Photo", systemImage: "photo")
                                .frame(maxWidth: .infinity, minHeight: 44)
                        }
                    }
                    .onChange(of: viewModel.selectedItem) { _ in
                        Task {
                            await viewModel.loadImage()
                        }
                    }
                }
                
                // Location
                Section("Location") {
                    Toggle("Add Current Location", isOn: $viewModel.includeLocation)
                }
            }
            .navigationTitle("New Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Post") {
                        Task {
                            await viewModel.createPost()
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
        }
    }
}

enum WorkoutType: String, CaseIterable, Identifiable {
    case strength = "Strength Training"
    case cardio = "Cardio"
    case hiit = "HIIT"
    case yoga = "Yoga"
    case crossfit = "CrossFit"
    case other = "Other"
    
    var id: String { rawValue }
} 