import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(viewModel.posts) { post in
                        FeedPostView(post: post)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Feed")
            .task {
                await viewModel.fetchPosts()
            }
        }
    }
}

struct FeedPostView: View {
    let post: FeedPost
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                // Profile Image
                ProfileImageView(imageUrl: post.userProfileImageUrl)
                
                VStack(alignment: .leading) {
                    Text(post.username)
                        .font(.headline)
                    
                    HStack {
                        if let timestamp = post.timestamp {
                            Text(timestamp, style: .relative)
                        }
                        if let location = post.workout.location {
                            Text("•")
                            Text(location)
                        }
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Menu {
                    Button(role: .destructive) {
                        // Report action
                    } label: {
                        Label("Report", systemImage: "exclamationmark.triangle")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.secondary)
                }
            }
            
            // Workout Summary
            workoutSummarySection
            
            // Description
            if let notes = post.workout.notes {
                Text(notes)
                    .font(.body)
                    .padding(.vertical, 4)
            }
            
            // Rating
            if let rating = post.workout.rating {
                HStack(spacing: 4) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= rating ? "star.fill" : "star")
                            .foregroundStyle(index <= rating ? .yellow : .gray.opacity(0.3))
                    }
                }
            }
            
            // Tagged Friends
            if let friends = post.workout.friends {
                Text(friends)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            // Interaction Bar
            HStack(spacing: 20) {
                Button {
                    // Like action
                } label: {
                    HStack {
                        Image(systemName: post.isLiked ? "heart.fill" : "heart")
                            .foregroundStyle(post.isLiked ? .red : .primary)
                        Text("\(post.likeCount)")
                    }
                }
                
                Button {
                    // Comment action
                } label: {
                    HStack {
                        Image(systemName: "bubble.right")
                        Text("\(post.commentCount)")
                    }
                }
                
                Button {
                    // Share action
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                
                Spacer()
            }
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var workoutSummarySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(post.workout.name)
                .font(.title3)
                .fontWeight(.bold)
            
            HStack(spacing: 16) {
                StatItem(
                    icon: "clock",
                    value: post.duration?.formattedTime ?? "0:00",
                    label: "Duration"
                )
                
                StatItem(
                    icon: "dumbbell",
                    value: "\(post.exerciseCount)",
                    label: "Exercises"
                )
                
                StatItem(
                    icon: "repeat",
                    value: "\(post.totalSets)",
                    label: "Total Sets"
                )
            }
        }
    }
}

struct ProfileImageView: View {
    let imageUrl: String?
    
    var body: some View {
        // TODO: Implement actual image loading
        Circle()
            .fill(.gray.opacity(0.2))
            .frame(width: 40, height: 40)
            .overlay {
                Image(systemName: "person.fill")
                    .foregroundStyle(.gray)
            }
    }
}

struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
