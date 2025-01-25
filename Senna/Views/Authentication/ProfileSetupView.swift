import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ProfileSetupView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var fullName = ""
    @State private var age = ""
    @State private var gender = Gender.preferNotToSay
    @State private var fitnessLevel = FitnessLevel.beginner
    @State private var showAlert = false
    @State private var isLoading = false
    
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
        ScrollView {
            VStack(spacing: Theme.spacing) {
                Text("Complete Your Profile")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Tell us a bit about yourself")
                    .foregroundColor(.secondary)
                    .padding(.bottom)
                
                VStack(spacing: Theme.spacing) {
                    // Full Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Full Name")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("", text: $fullName)
                            .textContentType(.name)
                            .textFieldStyle()
                    }
                    
                    // Age
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Age")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("", text: $age)
                            .keyboardType(.numberPad)
                            .textFieldStyle()
                    }
                    
                    // Gender
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Gender")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Picker("Gender", selection: $gender) {
                            ForEach(Gender.allCases, id: \.self) { gender in
                                Text(gender.rawValue).tag(gender)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    // Fitness Level
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Fitness Level")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Picker("Fitness Level", selection: $fitnessLevel) {
                            ForEach(FitnessLevel.allCases, id: \.self) { level in
                                Text(level.rawValue).tag(level)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                .padding(.bottom, Theme.spacing)
                
                Button {
                    Task {
                        await saveProfile()
                    }
                } label: {
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Complete Setup")
                            .fontWeight(.semibold)
                    }
                }
                .primaryButtonStyle()
                .disabled(!isFormValid || isLoading)
            }
            .padding()
        }
        .alert("Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Failed to save profile. Please try again.")
        }
    }
    
    private func saveProfile() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await Firestore.firestore().collection("users").document(userId).updateData([
                "fullName": fullName,
                "age": Int(age) ?? 0,
                "gender": gender.rawValue,
                "fitnessLevel": fitnessLevel.rawValue,
                "profileCompleted": true
            ])
            
            await $authManager.fetchUserProfile
        } catch {
            showAlert = true
        }
    }
} 
