import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(Theme.primaryColor)
                        
                        VStack(alignment: .leading) {
                            if let email = Auth.auth().currentUser?.email {
                                Text(email)
                                    .font(.headline)
                            }
                            Text("Member since \(Date().formatted(.dateTime.month().year()))")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Account") {
                    Button(role: .destructive) {
                        Task {
                            try? authManager.signOut()
                        }
                    } label: {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
} 