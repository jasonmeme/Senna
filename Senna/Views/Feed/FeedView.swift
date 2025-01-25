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
                await viewModel.fetchPosts()
            }
            .navigationTitle("Feed")
            .task {
                await viewModel.fetchPosts()
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
            Text(post.workoutType)
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