import SwiftUI

struct SetRowView: View {
    @Binding var set: ExerciseSet
    let onComplete: () -> Void
    @State private var offset: CGFloat = 0
    @State private var showWeightPicker = false
    @State private var showRepsPicker = false
    
    var body: some View {
        HStack(spacing: Theme.spacing) {
            // Set number
            Text("\(set.setNumber)")
                .frame(width: 30)
                .foregroundStyle(.secondary)
            
            // Weight
            Button {
                showWeightPicker = true
            } label: {
                Text("\(String(format: "%.1f", set.weight))kg")
                    .frame(width: 70, alignment: .leading)
                    .foregroundStyle(set.isComplete ? .secondary : .primary)
            }
            
            // Reps
            Button {
                showRepsPicker = true
            } label: {
                Text("\(set.reps) reps")
                    .frame(width: 70, alignment: .leading)
                    .foregroundStyle(set.isComplete ? .secondary : .primary)
            }
            
            Spacer()
            
            // Complete indicator
            Image(systemName: set.isComplete ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(set.isComplete ? .green : .secondary)
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .offset(x: offset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    if !set.isComplete {
                        offset = max(0, min(value.translation.width, 60))
                    }
                }
                .onEnded { value in
                    if value.translation.width > 50 && !set.isComplete {
                        withAnimation {
                            set.isComplete = true
                            offset = 0
                            onComplete()
                        }
                    } else {
                        withAnimation {
                            offset = 0
                        }
                    }
                }
        )
        .sheet(isPresented: $showWeightPicker) {
            WeightPickerView(weight: $set.weight)
        }
        .sheet(isPresented: $showRepsPicker) {
            RepsPickerView(reps: $set.reps)
        }
    }
}

struct WeightPickerView: View {
    @Binding var weight: Double
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Picker("Weight", selection: $weight) {
                ForEach(Array(stride(from: 0.0, through: 200.0, by: 2.5)), id: \.self) { value in
                    Text("\(String(format: "%.1f", value))kg").tag(value)
                }
            }
            .pickerStyle(.wheel)
            .navigationTitle("Select Weight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.height(250)])
    }
}

struct RepsPickerView: View {
    @Binding var reps: Int
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Picker("Reps", selection: $reps) {
                ForEach(0...100, id: \.self) { value in
                    Text("\(value) reps").tag(value)
                }
            }
            .pickerStyle(.wheel)
            .navigationTitle("Select Reps")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.height(250)])
    }
} 