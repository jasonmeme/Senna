import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var showEditProfile = false
    @State private var showSignOutAlert = false
    
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
                    
                    Button {
                        showSignOutAlert = true
                    } label: {
                        Text("Sign Out")
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.red)
                    .padding(.top)
                }
                .padding()
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showEditProfile, onDismiss: {
                Task {
                    await viewModel.fetchProfile()
                }
            }) {
                if let profile = viewModel.profile {
                    ProfileSetupView(isEditing: true, initialProfile: profile)
                }
            }
            .alert("Sign Out", isPresented: $showSignOutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    try? authManager.signOut()
                }
            } message: {
                Text("Are you sure you want to sign out?")
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