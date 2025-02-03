import SwiftUI
import PhotosUI

struct WorkoutCompletionView: View {
    @StateObject private var viewModel: WorkoutCompletionViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(workout: ActiveWorkoutViewModel) {
        _viewModel = StateObject(wrappedValue: WorkoutCompletionViewModel(workout: workout))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.spacing * 2) {
                    // Header Stats Section
                    statsSection
                    
                    // Main Content
                    VStack(spacing: Theme.spacing * 2) {
                        titleSection
                        workoutDetailsSection
                        photoSection
                        moodSection
                        locationSection
                        taggingSection
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Workout Summary")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save Draft") {
                        // TODO: Implement save draft
                    }
                }
            }
            
            // Bottom Action Button
            VStack {
                Divider()
                Button {
                    // TODO: Implement post workout
                } label: {
                    Text("Post Workout")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.accentColor)
                        .cornerRadius(Theme.cornerRadius)
                        .padding()
                }
            }
            .background(Theme.backgroundColor)
        }
    }
    
    private var statsSection: some View {
        VStack(spacing: Theme.spacing) {
            HStack(spacing: Theme.spacing * 2) {
                StatItemView(title: "Duration", value: viewModel.formattedDuration)
                Divider().frame(height: 30)
                StatItemView(title: "Exercises", value: "\(viewModel.exerciseCount)")
                Divider().frame(height: 30)
                StatItemView(title: "Total Sets", value: "\(viewModel.totalSets)")
            }
            .padding()
            .background(Theme.secondaryBackgroundColor)
            .cornerRadius(Theme.cornerRadius)
        }
        .padding(.horizontal)
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: Theme.spacing) {
            Text("Workout Title")
                .font(.headline)
                .foregroundStyle(.secondary)
            TextField("Enter workout title", text: $viewModel.workoutTitle)
                .font(.title3)
                .textFieldStyle(CustomRoundedBorderStyle())
        }
    }
    
    private var workoutDetailsSection: some View {
        VStack(alignment: .leading, spacing: Theme.spacing) {
            Text("Notes")
                .font(.headline)
                .foregroundStyle(.secondary)
            TextEditor(text: $viewModel.notes)
                .font(.body)
                .frame(height: 120)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: Theme.cornerRadius)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .padding(.vertical, 4)
        }
    }
    
    private var photoSection: some View {
        VStack(alignment: .leading, spacing: Theme.spacing/2) {
            Text("Photos")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Theme.spacing) {
                    ForEach(0..<3) { index in
                        PhotoPickerButton(
                            selectedItem: $viewModel.selectedPhotos[index],
                            imageState: viewModel.imageStates[index]
                        )
                    }
                }
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
                        viewModel.selectedMood = rating
                    } label: {
                        Image(systemName: rating <= viewModel.selectedMood ? "star.fill" : "star")
                            .font(.title)
                            .foregroundColor(rating <= viewModel.selectedMood ? .yellow : .gray.opacity(0.3))
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: Theme.spacing) {
            Text("Location")
                .font(.headline)
                .foregroundStyle(.secondary)
            TextField("Add location", text: $viewModel.location)
                .font(.body)
                .textFieldStyle(CustomRoundedBorderStyle())
        }
    }
    
    private var taggingSection: some View {
        VStack(alignment: .leading, spacing: Theme.spacing) {
            Text("Tag Friends")
                .font(.headline)
                .foregroundStyle(.secondary)
            TextField("@mention your friends", text: $viewModel.friendTags)
                .font(.body)
                .textFieldStyle(CustomRoundedBorderStyle())
                .frame(height: 56)
                .padding(.vertical, 4)
        }
    }
}

struct StatItemView: View {
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
            .padding(.horizontal, 16)  // More internal padding between text and border
            .padding(.vertical, 12)    // More internal padding between text and border
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.25), lineWidth: 0.5)
                    .background(Color.white)
            )
    }
} 