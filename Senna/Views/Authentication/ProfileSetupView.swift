import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ProfileSetupView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @Environment(\.dismiss) private var dismiss
    @State private var fullName: String
    @State private var age: String
    @State private var gender: Gender
    @State private var fitnessLevel: FitnessLevel
    @State private var showAlert = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    let isEditing: Bool
    
    init(isEditing: Bool = false, initialProfile: UserProfile? = nil) {
        self.isEditing = isEditing
        _fullName = State(initialValue: initialProfile?.fullName ?? "")
        _age = State(initialValue: initialProfile?.age.description ?? "")
        _gender = State(initialValue: Gender(rawValue: initialProfile?.gender ?? "") ?? .preferNotToSay)
        _fitnessLevel = State(initialValue: FitnessLevel(rawValue: initialProfile?.fitnessLevel ?? "") ?? .beginner)
    }
    
    enum Gender: String, CaseIterable {
        case male = "Male"
        case female = "Female"
        case preferNotToSay = "Prefer not to say"
    }
    
    enum FitnessLevel: String, CaseIterable {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"
    }
    
    private var isFormValid: Bool {
        !fullName.isEmpty && !age.isEmpty
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.spacing * 1.5) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Complete Your Profile")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Tell us a bit about yourself to get started")
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, Theme.spacing)
                    
                    // Form Fields
                    VStack(spacing: Theme.spacing * 1.5) {
                        // Full Name
                        FormField(title: "Full Name", text: $fullName, placeholder: "Enter your full name")
                            .textContentType(.name)
                            .autocapitalization(.words)
                        
                        // Age
                        FormField(title: "Age", text: $age, placeholder: "Enter your age")
                            .keyboardType(.numberPad)
                        
                        // Gender
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Gender")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Picker("Gender", selection: $gender) {
                                ForEach(Gender.allCases, id: \.self) { gender in
                                    Text(gender.rawValue).tag(gender)
                                }
                            }
                            .pickerStyle(.segmented)
                            .padding(2)
                        }
                        
                        // Fitness Level
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Fitness Level")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Picker("Fitness Level", selection: $fitnessLevel) {
                                ForEach(FitnessLevel.allCases, id: \.self) { level in
                                    Text(level.rawValue).tag(level)
                                }
                            }
                            .pickerStyle(.segmented)
                            .padding(2)
                        }
                    }
                    .padding(.vertical, Theme.spacing)
                    
                    // Buttons
                    VStack(spacing: Theme.spacing) {
                        Button {
                            Task {
                                await saveProfile()
                            }
                        } label: {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text(isEditing ? "Save Changes" : "Complete Setup")
                                    .fontWeight(.semibold)
                            }
                        }
                        .primaryButtonStyle()
                        .disabled(!isFormValid || isLoading)
                        
                        if !isEditing {
                            Button {
                                Task {
                                    await skipSetup()
                                }
                            } label: {
                                Text("Complete Later")
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.secondary)
                            .disabled(isLoading)
                        }
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
        .alert("Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage ?? "Failed to save profile. Please try again.")
        }
    }
    
    private func saveProfile() async {
        guard let userId = Auth.auth().currentUser?.uid else { 
            errorMessage = "User not found"
            showAlert = true
            return 
        }
        isLoading = true
        defer { 
            isLoading = false
            if isEditing {
                dismiss()
            }
        }
        
        do {
            try await Firestore.firestore().collection("users").document(userId).updateData([
                "fullName": fullName,
                "age": Int(age) ?? 0,
                "gender": gender.rawValue,
                "fitnessLevel": fitnessLevel.rawValue,
                "profileCompleted": true
            ])
            
            await authManager.fetchUserProfile()
        } catch {
            errorMessage = error.localizedDescription
            showAlert = true
        }
    }
    
    private func skipSetup() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await Firestore.firestore().collection("users").document(userId).updateData([
                "profileCompleted": true
            ])
            await authManager.fetchUserProfile()
        } catch {
            errorMessage = error.localizedDescription
            showAlert = true
        }
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
        }
    }
} 
