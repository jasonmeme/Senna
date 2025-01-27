import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showEditProfile = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.spacing * 2) {
                    // Profile Header
                    VStack(spacing: Theme.spacing) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.secondary)
                        
                        VStack(spacing: 4) {
                            Text(viewModel.profile?.fullName ?? "Complete Your Profile")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(viewModel.profile?.email ?? "")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top)
                    
                    // Profile Info
                    if let profile = viewModel.profile {
                        VStack(spacing: Theme.spacing * 1.5) {
                            InfoRow(title: "Age", value: "\(profile.age)")
                            InfoRow(title: "Gender", value: profile.gender)
                            InfoRow(title: "Fitness Level", value: profile.fitnessLevel)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemBackground))
                                .shadow(color: .black.opacity(0.05), radius: 10)
                        )
                    }
                    
                    Button {
                        showEditProfile = true
                    } label: {
                        Text("Edit Profile")
                            .fontWeight(.semibold)
                    }
                    .primaryButtonStyle()
                }
                .padding()
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showEditProfile) {
                ProfileSetupView()
            }
        }
        .task {
            await viewModel.fetchProfile()
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
} 