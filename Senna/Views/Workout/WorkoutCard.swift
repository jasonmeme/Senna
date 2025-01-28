import SwiftUICore
import FirebaseAuth
import FirebaseFirestore

struct WorkoutCard: View {
    let workout: Workout
    @StateObject private var viewModel = WorkoutCardViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing) {
            // User Info Header
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.userName)
                        .font(.headline)
                    Text(workout.startTime.formatted())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // ... rest of the workout card ...
        }
        .task {
            await viewModel.fetchUserName(userId: workout.userId)
        }
    }
}

// Add a new ViewModel for the WorkoutCard
@MainActor
class WorkoutCardViewModel: ObservableObject {
    @Published var userName: String = "Loading..."
    
    func fetchUserName(userId: String) async {
        do {
            let document = try await Firestore.firestore()
                .collection("users")
                .document(userId)
                .getDocument()
            
            if let data = document.data(), let name = data["fullName"] as? String {
                userName = name
            }
        } catch {
            print("Error fetching user name: \(error.localizedDescription)")
            userName = "Unknown User"
        }
    }
} 
