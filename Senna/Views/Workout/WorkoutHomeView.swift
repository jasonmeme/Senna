import SwiftUI

struct WorkoutHomeView: View {
    @StateObject private var viewModel = WorkoutHomeViewModel()
    @State private var showWorkoutTypeSheet = false
    @State private var showTemplateSelection = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.spacing * 1.5) {
                    // Quick Start Section
                    VStack(spacing: Theme.spacing) {
                        Button {
                            showWorkoutTypeSheet = true
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Start New Workout")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(Theme.cornerRadius)
                        }
                        
                        Button {
                            showTemplateSelection = true
                        } label: {
                            HStack {
                                Image(systemName: "doc.fill")
                                Text("Use Template")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.secondaryBackgroundColor)
                            .foregroundColor(.primary)
                            .cornerRadius(Theme.cornerRadius)
                        }
                    }
                    .padding()
                    .background(Theme.secondaryBackgroundColor)
                    .cornerRadius(Theme.cornerRadius)
                    
                    // Recent Workouts Section
                    RecentWorkoutsSection(workouts: viewModel.recentWorkouts)
                    
                    // Templates Sections
                    MyTemplatesSection(templates: viewModel.userTemplates)
                    BrowseTemplatesSection(templates: viewModel.popularTemplates)
                }
                .padding()
            }
            .navigationTitle("Workout")
            .sheet(isPresented: $showWorkoutTypeSheet) {
                WorkoutTypeSelectionSheet()
            }
            .sheet(isPresented: $showTemplateSelection) {
                TemplateSelectionView()
            }
            .task {
                await viewModel.loadData()
            }
        }
    }
}

struct WorkoutTypeSelectionSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(WorkoutType.allCases) { type in
                    NavigationLink {
                        switch type {
                        case .strength:
                            StrengthWorkoutView()
                        case .running, .cycling, .swimming:
                            EmptyView()
                        default:
                            EmptyView()
                        }
                    } label: {
                        HStack {
                            Image(systemName: type.icon)
                                .frame(width: 30)
                            Text(type.rawValue)
                        }
                    }
                }
            }
            .navigationTitle("Select Workout Type")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
} 
