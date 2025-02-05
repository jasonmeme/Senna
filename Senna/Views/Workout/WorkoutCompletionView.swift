import SwiftUI
import PhotosUI

struct WorkoutCompletionView: View {
    @StateObject var viewModel: WorkoutViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.spacing) {
                    // Workout Stats
                    statsSection
                    
                    // Exercises Summary
                    exercisesSection
                    
                    // Rating
                    moodSection
                    
                    // Notes & Location
                    notesSection
                    locationSection
                    
                    // Save Button
                    saveButton
                }
                .padding()
            }
            .navigationTitle("Workout Complete")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: Theme.spacing) {
            Text("Workout Stats")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            HStack {
                StatView(
                    title: "Duration",
                    value: viewModel.elapsedTime.formattedTime
                )
                Divider()
                StatView(
                    title: "Exercises",
                    value: "\(viewModel.workout.exercises.count)"
                )
                Divider()
                StatView(
                    title: "Total Sets",
                    value: "\(viewModel.workout.exercises.reduce(0) { $0 + $1.sets.count })"
                )
            }
            .cardStyle()
        }
    }
    
    private var exercisesSection: some View {
        VStack(alignment: .leading, spacing: Theme.spacing) {
            Text("Exercises")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            ForEach($viewModel.exercises) { $exercise in
                ExerciseCard(exercise: $exercise, onDelete: nil)
            }
        }
    }
    
    private var moodSection: some View {
        VStack(alignment: .leading, spacing: Theme.spacing) {
            Text("How was your workout?")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            HStack(spacing: Theme.spacing * 1.5) {
                ForEach(1...5, id: \.self) { rating in
                    Button {
                        viewModel.rating = rating
                    } label: {
                        Image(systemName: rating <= (viewModel.rating ?? 0) ? "star.fill" : "star")
                            .font(.title)
                            .foregroundColor(rating <= (viewModel.rating ?? 0) ? .yellow : .gray.opacity(0.3))
                    }
                }
            }
            .cardStyle()
        }
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: Theme.spacing/2) {
            Text("Notes")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            TextField("Add workout notes", text: Binding(
                get: { viewModel.notes ?? "" },
                set: { viewModel.notes = $0.isEmpty ? nil : $0 }
            ))
            .textFieldStyle(.roundedBorder)
        }
    }
    
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: Theme.spacing/2) {
            Text("Location")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            TextField("Add location", text: Binding(
                get: { viewModel.location ?? "" },
                set: { viewModel.location = $0.isEmpty ? nil : $0 }
            ))
            .textFieldStyle(.roundedBorder)
        }
    }
    
    private var saveButton: some View {
        Button {
            Task {
                do {
                    try await viewModel.saveWorkout()
                    dismiss()
                } catch {
                    showingError = true
                }
            }
        } label: {
            Text("Save Workout")
                .frame(maxWidth: .infinity)
                .primaryButtonStyle()
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Failed to save workout. Please try again.")
        }
    }
}

private struct StatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct PhotoPickerButton: View {
    @Binding var selectedItem: PhotosPickerItem?
    let imageState: Image?
    
    var body: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            if let image = imageState {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
            } else {
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .fill(Theme.secondaryBackgroundColor)
                    .frame(width: 100, height: 100)
                    .overlay {
                        Image(systemName: "plus")
                            .foregroundStyle(.secondary)
                    }
            }
        }
    }
}

struct CustomRoundedBorderStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1.5)
                    .background(Color.white)
            )
    }
} 

