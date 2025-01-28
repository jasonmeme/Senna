import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: Theme.spacing) {
                    ForEach(viewModel.posts) { post in
                        WorkoutPostCard(post: post)
                            .cardStyle()
                    }
                }
                .padding()
            }
            .refreshable {
                await viewModel.loadPosts()
            }
            .navigationTitle("Feed")
            .task {
                await viewModel.loadPosts()
            }
        }
    }
}

struct WorkoutPostCard: View {
    let post: WorkoutPost
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing) {
            // User info header
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text(post.username)
                        .font(.headline)
                    Text(post.formattedDate)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            // Workout image if available
            if let imageURL = post.imageURL {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                } placeholder: {
                    Rectangle()
                        .fill(Theme.secondaryBackgroundColor)
                        .frame(height: 200)
                }
            }
            
            // Workout details
            Text(post.workoutType.id)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text(post.description)
                .font(.body)
            
            // Interaction buttons
            HStack {
                Button {
                    // Like action
                } label: {
                    Label("\(post.likes)", systemImage: "heart")
                }
                
                Button {
                    // Comment action
                } label: {
                    Label("\(post.comments)", systemImage: "bubble.right")
                }
                
                Spacer()
            }
            .foregroundStyle(.secondary)
        }
    }
}

struct FeedPostView: View {
    let post: WorkoutPost
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing) {
            // Header
            HStack {
                Text(post.username)
                    .font(.headline)
                Spacer()
                Text(post.formattedDate)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // Content
            if let imageURL = post.imageURL {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(.secondary.opacity(0.2))
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
            }
            
            Text(post.title)
                .font(.headline)
            
            Text(post.description)
                .font(.body)
            
            // Workout details
            if let exercises = post.exercises {
                VStack(alignment: .leading, spacing: Theme.spacing/2) {
                    ForEach(exercises, id: \.name) { exercise in
                        Text("\(exercise.name): \(exercise.sets.count) sets")
                            .font(.subheadline)
                    }
                }
                .padding(.top, Theme.spacing/2)
            }
            
            // Engagement
            HStack {
                Label("\(post.likes)", systemImage: "heart")
                Label("\(post.comments)", systemImage: "bubble.right")
                Spacer()
                Text(post.workoutType.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.secondary.opacity(0.2))
                    .clipShape(Capsule())
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(Theme.secondaryBackgroundColor)
        .cornerRadius(Theme.cornerRadius)
    }
} 
