import SwiftUI

struct SetRow: View {
    let index: Int
    @Binding var set: SetData
    let showCompletion: Bool
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Set number
            Text("\(index + 1)")
                .foregroundStyle(.secondary)
                .frame(width: 40, alignment: .leading)
            
            // Weight TextField
            TextField("0", value: $set.weight, format: .number)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .frame(width: 70)
                .textFieldStyle(.roundedBorder)
                .onChange(of: set.weight) { newValue in
                    // Ensure weight is non-negative
                    set.weight = max(newValue, 0)
                }
            
            // Reps TextField
            TextField("0", value: $set.reps, format: .number)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .frame(width: 70)
                .textFieldStyle(.roundedBorder)
                .onChange(of: set.reps) { newValue in
                    // Keep reps between 1 and 100
                    set.reps = min(max(newValue, 1), 100)
                }
            
            Spacer()
            
            // Completion Checkbox (only shown in active state)
            if showCompletion {
                Button {
                    set.isCompleted.toggle()
                } label: {
                    Image(systemName: set.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(set.isCompleted ? Theme.accentColor : .secondary)
                }
                .frame(width: 50)
            }
        }
        .font(.subheadline)
        .padding(.horizontal)
        .contentShape(Rectangle())
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive, action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

// Preview
#Preview {
    VStack {
        // Template state
        SetRow(
            index: 0,
            set: .constant(SetData(weight: 135, reps: 8)),
            showCompletion: false,
            onDelete: {}
        )
        
        // Active state
        SetRow(
            index: 1,
            set: .constant(SetData(weight: 135, reps: 8, isCompleted: true)),
            showCompletion: true,
            onDelete: {}
        )
    }
    .padding()
    .background(Theme.secondaryBackgroundColor)
} 