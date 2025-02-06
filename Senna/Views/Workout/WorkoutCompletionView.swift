import SwiftUI
import PhotosUI

struct WorkoutCompletionView: View {
    @StateObject var viewModel: WorkoutViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingError = false
    @State private var workoutTitle: String
    
    init(viewModel: WorkoutViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        // Set initial title based on time of day
        let hour = Calendar.current.component(.hour, from: Date())
        let timePrefix = switch hour {
        case 5..<12: "Morning"
        case 12..<17: "Afternoon"
        case 17..<21: "Evening"
        default: "Night"
        }
        _workoutTitle = State(initialValue: "\(timePrefix) \(viewModel.workout.name)")
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: Theme.spacing) {
                        statsSection
                        titleSection
                        storySection
                        locationSection
                        friendsSection
                        moodSection
                        exercisesSection
                    }
                    .padding()
                    .padding(.bottom, 100)
                }
                postButton
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

    private var postButton: some View {
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
            Text("Post Workout")
                .font(.body.weight(.medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: Theme.cornerRadius)
                        .fill(Theme.accentColor)
                )
                .padding(.horizontal, 24)
        }
        .padding(.vertical, 16)
        .background(.white)
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Failed to save workout. Please try again.")
        }
    }
    
    private var titleSection: some View {
        CustomTextField(
            text: $workoutTitle,
            placeholder: "Name your workout"
        )
    }
    
    private var storySection: some View {
        CustomTextEditor(
            text: Binding(
                get: { viewModel.notes ?? "" },
                set: { viewModel.notes = $0.isEmpty ? nil : $0 }
            ),
            placeholder: "Add your workout story"
        )
    }
    
    private var locationSection: some View {
        CustomTextField(
            text: Binding(
                get: { viewModel.location ?? "" },
                set: { viewModel.location = $0.isEmpty ? nil : $0 }
            ),
            placeholder: "Where did you train?"
        )
    }
    
    private var friendsSection: some View {
        CustomTextField(
            text: Binding(
                get: { viewModel.friends ?? "" },
                set: { viewModel.friends = $0.isEmpty ? nil : $0 }
            ),
            placeholder: "Tag your workout buddies"
        )
    }
    
    private var statsSection: some View {
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
}

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        TextField(placeholder, text: $text)
            .focused($isFocused)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .stroke(isFocused ? Theme.accentColor : Color.gray.opacity(0.5), lineWidth: 1.5)
                    .background(Color.white)
            )
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


struct CustomTextEditor: View {
    @Binding var text: String
    let placeholder: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
            }
            
            TextEditor(text: $text)
                .frame(height: 100)  // Makes the text editor taller
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .focused($isFocused)
        }
        .background(
            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                .stroke(isFocused ? Theme.accentColor : Color.gray.opacity(0.5), lineWidth: 1.5)
                .background(Color.white)
        )
    }
} 

